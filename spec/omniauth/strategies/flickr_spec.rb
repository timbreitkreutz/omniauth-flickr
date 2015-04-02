require 'spec_helper'
require 'omniauth/strategies/flickr'
require "addressable/uri"

RSpec.describe OmniAuth::Strategies::Flickr, type: :strategy do

  let(:app) do
    Rack::Builder.new {
      use OmniAuth::Test::PhonySession
      use OmniAuth::Builder do
        provider :flickr, ENV['FLICKR_KEY'], ENV['FLICKR_SECRET'], scope: 'read'
      end
      run lambda { |env| [404, {'Content-Type' => 'text/plain'}, [env.key?('omniauth.auth').to_s]] }
    }.to_app
  end

  let(:session) { last_request.env['rack.session'] }

  before do
    stub_request(:post, "https://www.flickr.com/services/oauth/request_token").
        to_return(:body => "oauth_token=yourtoken&oauth_token_secret=yoursecret&oauth_callback_confirmed=true")
  end

  describe '/auth/flickr' do

    before { get '/auth/flickr' }

    it 'should redirect to authorize_url' do
      expect(last_response.headers['Location']).to \
        eq "https://www.flickr.com/services/oauth/authorize?perms=read&oauth_token=yourtoken"
    end

    it 'should set appropriate session variables' do
      expect(session['oauth']['flickr']).to eq({
                                                   'callback_confirmed' => true,
                                                   'request_token' => 'yourtoken',
                                                   'request_secret' => 'yoursecret'
                                               })
    end
  end

  describe '/auth/flickr/callback' do
    let(:session) {
      {
          'rack.session' => {
              'oauth' => {
                  "flickr" => {
                      'callback_confirmed' => true,
                      'request_token' => 'yourtoken',
                      'request_secret' => 'yoursecret'
                  }
              }
          }
      }
    }
    let(:auth_response) { last_request.env['omniauth.auth'] }
    let(:get_info) {
      IO.binread(File.dirname(__FILE__) + "/flickr.people.getInfo.json")
    }

    before do
      stub_request(:post, 'https://www.flickr.com/services/oauth/access_token').
          to_return(:body => "oauth_token=yourtoken&oauth_token_secret=yoursecret&username=j.bloggs&fullname=John Bloggs&user_nsid=ABC123")

      stub_request(:get, 'https://www.flickr.com/services/rest/?format=json&method=flickr.people.getInfo&nojsoncallback=1&user_id=ABC123')
        .to_return(:body => get_info)

      get '/auth/flickr/callback', {:oauth_verifier => 'dudeman'}, session
    end

    it 'calls through to the master app' do
      expect(last_response.body).to eq 'true'
    end

    it 'exchanges the request token for an access token' do
      expect(auth_response['provider']).to eq 'flickr'
      expect(auth_response['extra']['access_token']).to be_kind_of(OAuth::AccessToken)
    end

    it "has the correct UID" do
      expect(auth_response.uid).to eq "ABC123"
    end

    describe "auth_response.info" do
      subject { auth_response['info'] }

      its(:nickname) { should eq "j.bloggs" }
      its(:name) { should eq "John Bloggs" }
      its(:image) { should eq 'http://farm9.static.flickr.com/8061/buddyicons/ABC123.jpg' }
      its(:ispro) { should eq 0 }
      its(:iconserver) { should eq "8061" }
      its(:iconfarm) { should eq 9 }
      its(:path_alias) { should eq "test string" }
      its(:urls) { should eq({
           "Photos" => "https://www.flickr.com/photos/ABC123/",
           "Profile" => "https://www.flickr.com/people/ABC123/",
      })}
      its(:mbox_sha1sum) { should eq "f9aa1a7919dea99ba86c773f58381aebc91e333d"}
      its(:location) { should eq "Gotham, USA" }
    end
  end
end