$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'net/http'
require 'uri'
require 'cgi'

module Gupshup
  VERSION = '0.1.0'
  class Enterprise
    def initialize(login,password)
      @api_url = 'http://enterprise.smsgupshup.com/GatewayAPI/rest'
      @api_params = {}
      @api_params[:userid] = login
      @api_params[:password] = password
      @api_params[:v] = '1.1'
      @api_params[:auth_scheme] = 'PLAIN'
    end

    def send_message(msg,number,msg_type = 'TEXT',opts = {})
      raise 'Phone Number is too short' if number.to_s.length < 12
      raise 'Phone Number is too long' if number.to_s.length > 12
      #raise 'Phone Number should start with "91"' if number.to_s.start_with? "91"
      raise 'Phone Number should be numerical value' unless number.to_i.to_s == number.to_s
      raise 'Message should be less than 725 characters long' if msg.to_s.length > 724
      msg_params = {}
      msg_params[:method] = 'sendMessage'
      msg_params[:msg_type] = msg_type.to_s
      msg_params[:msg] = msg.to_s
      msg_params[:send_to] = number.to_s
      #url = URI.parse(@api_url)
      #req = Net::HTTP::Post.new(url.path)
      #puts "--- #{msg_params.merge(@api_params).inspect}"
      #req.set_form_data(msg_params.merge(@api_params))
      #res = Net::HTTP.new(url.host, url.port).start {|http|http.request(req) }
      res = Net::HTTP.post_form(
        URI.parse(@api_url),
        msg_params.merge(@api_params).merge(opts)
      )
      resp = res.body
      puts "GupShup Response: #{resp}"

      case res
      when Net::HTTPSuccess, Net::HTTPRedirection
        if resp.nil? || resp.include?("success") == false
          raise "SMS Sending failed: #{resp}"
        end
        return true
      else
        raise 'GupShup returned HTTP Error'
      end
    end

    def send_flash_message(msg,number,opts = {})
      send_message(msg,number,:FLASH,opts)
    end

    def send_text_message(msg,number,opts = {})
      send_message(msg,number,:TEXT,opts)
    end

    def send_vcard(card,number,opts = {})
      send_message(card,number,:VCARD,opts)
    end

    def send_unicode_message(msg,number,opts = {})
      send_message(msg,number,:UNICODE_TEXT,opts)
    end
  end
end
