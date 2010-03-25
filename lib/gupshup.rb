$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'net/http'
require 'uri'
require 'cgi'
require 'httpclient'

class NilClass
  def blank?
    true
  end
end

class String
  def blank?
    self.empty?
  end
end

module Gupshup
  VERSION = '0.1.5'
  class Enterprise
    def initialize(opts)
      @api_url = 'http://enterprise.smsgupshup.com/GatewayAPI/rest'
      @api_params = {}
      @api_params[:userid] = opts[:userid]
      @api_params[:password] = opts[:password]
      @api_params[:v] = opts[:v] || '1.1'
      @api_params[:auth_scheme] = opts[:auth_scheme] || 'PLAIN'
      unless opts[:token].blank?
        @api_params[:auth_scheme] = 'TOKEN'
        @api_params[:token] = opts[:token]
        @api_params.delete(:password)
      end
      raise "Invalid credentials" if opts[:userid].blank? || (opts[:password].blank? && opts[:token].blank?)
    end
    
    def call_api(opts = {})
      res = Net::HTTP.post_form(
        URI.parse(@api_url),
        @api_params.merge(opts)
      )
      resp = res.body
      puts "GupShup Response: #{resp}"

      case res
      when Net::HTTPSuccess, Net::HTTPRedirection
        if resp.nil? || resp.include?("success") == false
          raise "API call '#{opts[:method]}' failed: #{resp}"
        end
        return true
      else
        raise 'GupShup returned HTTP Error'
      end
    end

    def send_message(opts)
      msg = opts[:msg]
      number = opts[:send_to]
      msg_type = opts[:msg_type] || 'TEXT'
      
      raise 'Phone Number is too short' if number.to_s.length < 12
      raise 'Phone Number is too long' if number.to_s.length > 12
      #raise 'Phone Number should start with "91"' if number.to_s.start_with? "91"
      raise 'Phone Number should be numerical value' unless number.to_i.to_s == number.to_s
      raise 'Message should be less than 725 characters long' if msg.to_s.length > 724
      call_api opts.merge({ :method => 'sendMessage' })
    end

    def send_flash_message(opts)
      send_message(opts.merge({ :msg_type => 'FLASH'}))
    end

    def send_text_message(opts)
      send_message(opts.merge({ :msg_type => 'TEXT'}))
    end

    def send_vcard(opts)
      send_message(opts.merge({ :msg_type => 'VCARD'}))
    end

    def send_unicode_message(opts)
      send_message(opts.merge({ :msg_type => 'UNICODE_TEXT'}))
    end

    def bulk_file_upload(file_path,file_type = 'csv',mime_type = 'text/csv', opts = {})
      msg_params = {}
      msg_params[:method] = 'xlsUpload'
      msg_params[:filetype] = file_type.to_s
      file = File.new(file_path,"r")
      def file.mime_type; "text/csv"; end
      msg_params[:xlsFile] = file
      resp = HTTPClient.post(@api_url,msg_params.merge(@api_params).merge(opts))
      file.close
      puts resp.body.content
    end
    
    def group_post(opts)
      raise "Invalid group name" if opts[:group_name].blank?
      raise "Invalid message" if opts[:msg].blank?
      raise "Invalid message type" if opts[:msg_type].blank?
      call_api opts.merge({:method => 'post_group'})
    end
  end
end
