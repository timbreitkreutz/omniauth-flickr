require 'omniauth-oauth'
require 'multi_json'

module OmniAuth
  module Strategies

    # An omniauth 1.0 strategy for Flickr authentication
    # Based on http://www.flickr.com/services/api/auth.oauth.html
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
        {
          :name => access_token.params['username'],
          :nickname => access_token.params['fullname'],
          :ispro => user_info["ispro"],
          :iconserver => user_info["iconserver"],
          :iconfarm => user_info["iconfarm"],
          :path_alias => user_info["path_alias"],
          :urls => {
            "Photos" => user_info["photosurl"],
            "Profile" => user_info["profileurl"],
          },
          :mbox_sha1sum => user_info["mbox_sha1sum"],
          :location => user_info["location"],
          :image => "http://farm#{user_info["iconfarm"]}.static.flickr.com/#{user_info["iconserver"]}/buddyicons/#{uid}.jpg"
        }
      end
      
      extra do
       {
          :raw_info => raw_info
       }
      end

      # Return info gathered from the flickr.people.getInfo API call 
     
      def raw_info
        # This is a public API and does not need signing or authentication
        request = "/services/rest/?format=json&method=flickr.people.getInfo&nojsoncallback=1&user_id=#{uid}"
        @raw_info ||= MultiJson.decode(access_token.get(request).body)
      rescue ::Errno::ETIMEDOUT
        raise ::Timeout::Error
      end

      # Provide the "Person" portion of the raw_info
      
      def user_info
        @user_info ||= raw_info.nil? ? {} : raw_info["person"]
      end
    end
  end
end
