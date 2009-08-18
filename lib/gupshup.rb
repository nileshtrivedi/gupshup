$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'net/http'
require 'uri'
require 'cgi'

module Gupshup
  VERSION = '0.0.1'
  class Enterprise
    def initialize(login,password)
      @api_url = 'http://enterprise.smsgupshup.com/GatewayAPI/rest'
      @api_params = {}
      @api_params[:userid] = login
      @api_params[:password] = password
      @api_params[:v] = '1.1'
      @api_params[:auth_scheme] = 'PLAIN'
    end

    def send_message(msg,number,msg_type = 'TEXT')
      msg_params = {}
      msg_params[:method] = 'sendMessage'
      msg_params[:msg_type] = msg_type
      msg_params[:msg] = msg.to_s
      msg_params[:send_to] = CGI.escape(number.to_i.to_s)
      url = URI.parse(@api_url)
      req = Net::HTTP::Post.new(url.path)
      puts "--- #{msg_params.merge(@api_params).inspect}"
      req.set_form_data(msg_params.merge(@api_params))
      res = Net::HTTP.new(url.host, url.port).start {|http|http.request(req) }
      success = false
      case res
      when Net::HTTPSuccess, Net::HTTPRedirection
        resp = res.body
        success = true
      else
        puts "---#{res.body}"
      end
      if resp.nil? || resp.include?("success") == false
        puts "############## SMS Sending failed - #{resp}"
        success = false
      end
      return success    
    end

    def send_flash_message(msg,number)
      send_message(msg,number,'FLASH')
    end

    def send_text_message(msg,number)
      send_message(msg,number,'TEXT')
    end
  end
end
