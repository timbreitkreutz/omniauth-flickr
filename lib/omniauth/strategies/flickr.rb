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
          :full_name => access_token.params['fullname']
        }
      end
      
      extra do
        {}
      end
    end
  end
end
