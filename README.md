# An Omniauth 1.0 Strategy for Flickr

## Basic setup example

```RUBY
  Rails.application.config.middleware.use OmniAuth::Builder do
    provider :flickr, ENV['FLICKR_KEY'], ENV['FLICKR_SECRET'], scope: 'read'
  end
```
A scope must be set, which translate to the `perms` parameter in the request url. Valid perms (scopes) are `read`, `write` and `delete`.

## For more information see the following:

 * https://github.com/intridea/omniauth/wiki/List-of-Strategies
 * https://www.flickr.com/services/api/auth.howto.web.html
 
## Release notes:

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

 * Version 0.0.5

  - Most available user information should now be available in the info hash - Still needs some testing and
  documentation--to come - Fixed a rescue so it is more contained

 * Version 0.0.4

  - Added more user info explicitly into the info hash

 * Version 0.0.1

  - First cut


