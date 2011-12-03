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
        {
          :username => access_token.params['username'],
          :fullname => access_token.params['fullname'],
          :ispro => user_info["ispro"],
          :iconserver => user_info["iconserver"],
          :iconfarm => user_info["iconfarm"],
          :path_alias => user_info["path_alias"],
          :photosurl => user_info["photosurl"],
          :profileurl => user_info["profileurl"],
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

      def raw_info
        # This is a public API and does not need signing or authentication
        url = "/services/rest/?api_key=#{options.consumer_key}&format=json&method=flickr.people.getInfo&nojsoncallback=1&user_id=#{uid}"
        @raw_info ||= Net::HTTP.get(options.client_options[:site].gsub(/.*:\/\//, ""), url)
      rescue ::Errno::ETIMEDOUT
        raise ::Timeout::Error
      end
      
      def user_info
        unless @user_info
          @user_info = {}
          info = MultiJson.decode(raw_info)
          @user_info = info["person"] unless info.nil?
        end
        @user_info
      end
    end
  end
end
