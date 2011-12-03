require 'omniauth-oauth'
require 'multi_json'

module OmniAuth
  module Strategies
    class Flickr < OmniAuth::Strategies::OAuth
      
      option :name, 'flickr'
      
      option :client_options, {
        :access_token_path => "/services/oauth/access_token",
        :authorize_path => "/services/oauth/authorize",
        :request_token_path => "/services/oauth/request_token",
        :site => "http://www.flickr.com"
      }

      uid { 
        access_token.params['user_nsid']
      }
      
      info do 
        user_info
      end
      
      extra do
        {}
      end
      
      def user_info
        if @user_info.blank?
          @user_info = {}
          # This is a public API and does not need signing or authentication
          url = "/services/rest/?api_key=#{options.consumer_key}&format=json&method=flickr.people.getInfo&nojsoncallback=1&user_id=#{uid}"
          response = Net::HTTP.get(options.client_options[:site].gsub(/.*:\/\//, ""), url)
          @user_info ||= MultiJson.decode(response.body) if response
        end
        @user_info
      rescue ::Errno::ETIMEDOUT
        raise ::Timeout::Error
      end
    end
  end
end
