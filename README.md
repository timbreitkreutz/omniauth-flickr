An Omniauth 1.0 Strategy for Flickr

For more information see the following:

 * https://github.com/intridea/omniauth/wiki/List-of-Strategies

Release notes:

 * Version 0.0.10
 
  - Fix bugs for users without avatars (thanks viseztrance)

 * Version 0.0.9

  - Allow :scope => 'read' in omniauth setup options
  
 * Version 0.0.8
 
   - Use authenticated version of flickr.people.getInfo (contrary to flickr docs, api_key must not be specified on url)

 * Version 0.0.7
 
   - Documentation and comment change only

 * Version 0.0.6 

   - Comply more closely to published Auth Hash Schema
     (https://github.com/intridea/omniauth/wiki/Auth-Hash-Schema)

 * Version 0.0.5 
 
   - Most available user information should now be available in the info hash
   - Still needs some testing and documentation--to come
   - Fixed a rescue so it is more contained

 * Version 0.0.4

   - Added more user info explicitly into the info hash

 * Version 0.0.1

   - First cut
