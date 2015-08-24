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
        :site => "https://www.flickr.com"
      }

      uid {
        access_token.params['user_nsid']
      }

      info do

        user_info_unwrapped = unwrap_hash_content(user_info.clone)
        {
          :name => access_token.params['fullname'],
          :nickname => access_token.params['username'],
          :ispro => user_info_unwrapped["ispro"],
          :iconserver => user_info_unwrapped["iconserver"],
          :iconfarm => user_info_unwrapped["iconfarm"],
          :path_alias => user_info_unwrapped["path_alias"],
          :urls => {
            "Photos" => user_info_unwrapped["photosurl"],
            "Profile" => user_info_unwrapped["profileurl"],
          },
          :mbox_sha1sum => user_info_unwrapped["mbox_sha1sum"],
          :location => user_info_unwrapped["location"],
          :image => image_info
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

      def image_info
        if user_info["iconfarm"] && user_info["iconfarm"] > 0
          "http://farm#{user_info["iconfarm"]}.static.flickr.com/#{user_info["iconserver"]}/buddyicons/#{uid}.jpg"
        else
          "https://www.flickr.com/images/buddyicon.gif"
        end
      end

      def request_phase
        options[:authorize_params] = {:perms => options[:scope]} if options[:scope]
        session['oauth'] ||= {} # https://github.com/timbreitkreutz/omniauth-flickr/issues/4
        super
      end

      private
      # Flickr has a really annoying habit of wrapping values in { "_content" : "something" }
      # This loops through an auth hash and converts these values into simple key / val
      def unwrap_hash_content(hash)
        hash.each do  |key, val|
          if val.respond_to? :has_key?
            hash[key] = val['_content'] if val.has_key?('_content')
          end
        end
      end
    end
  end
end
