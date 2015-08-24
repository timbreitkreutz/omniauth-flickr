# omniauth-flickr
## An Omniauth 1.0 Strategy for Flickr

## Basic setup example

```RUBY
  Rails.application.config.middleware.use OmniAuth::Builder do
    provider :flickr, ENV['FLICKR_KEY'], ENV['FLICKR_SECRET'], scope: 'read'
  end
```
A scope must be set, which translate to the `perms` parameter in the request url. 
Valid perms (scopes) are `read`, `write` and `delete`.
Info about the authenticated user is fetched from [flickr.people.getInfo](https://www.flickr.com/services/api/flickr.people.getInfo.html).

Example [AuthHash](https://github.com/intridea/omniauth/wiki/Auth-Hash-Schema) from a successful authentication:

```YML
provider: flickr
uid: 62839091@N05
info: !ruby/hash:OmniAuth::AuthHash::InfoHash
  name: Example User
  nickname: example_user
  ispro: 0
  iconserver: '8061'
  iconfarm: 9
  path_alias: 
  urls: !ruby/hash:OmniAuth::AuthHash
    Photos: !ruby/hash:OmniAuth::AuthHash
      _content: https://www.flickr.com/photos/62839091@N05/
    Profile: !ruby/hash:OmniAuth::AuthHash
      _content: https://www.flickr.com/people/62839091@N05/
  mbox_sha1sum: !ruby/hash:OmniAuth::AuthHash
    _content: f9aa1a7919dea99ba86c773f58381aebc91e333d
  location: !ruby/hash:OmniAuth::AuthHash
    _content: "Åre, Sweden"
  image: http://farm9.static.flickr.com/8061/buddyicons/62839091@N05.jpg
credentials: !ruby/hash:OmniAuth::AuthHash
  token: 72157650421100317-c02692b6059aa1f3
  secret: 75174bc4da58893a
# ...
```

## For more information see the following:

 * https://github.com/intridea/omniauth/wiki/List-of-Strategies
 * https://www.flickr.com/services/api/auth.howto.web.html
 
## Release notes:

 * Version 0.0.19

  - Add licence to gemspec
  - Add some defensive code for jruby (see https://github.com/timbreitkreutz/omniauth-flickr/issues/4)

 * Version 0.0.18

  - add test cases from Maxcal

 * Version 0.0.17

  - better examples and documentation, fix reversed name and nickname (thanks @maxcal)

 * Version 0.0.15

  - Use HTTPS for default icon (see://www.flickr.com/services/api/misc.buddyicons.html) 

 * Version 0.0.14

  - Use new HTTPS endpoint for API - thanks @rubyonrails3

 * Version 0.0.13

  - better default avatar, thanks to Brainimus

 * Version 0.0.11

  - Fix bugs for users without avatars (thanks viseztrance)

 * Version 0.0.9

  - Allow :scope => 'read' in omniauth setup options

 * Version 0.0.8

  - Use authenticated version of flickr.people.getInfo (contrary to flickr docs, api_key must not be specified on
  url)

 * Version 0.0.7

  - Documentation and comment change only

 * Version 0.0.6

  - Comply more closely to published Auth Hash Schema (https://github.com/intridea/omniauth/wiki/Auth-Hash-Schema)
