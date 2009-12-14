In order for this application to work properly, there are two files that you need to create, with the following defined
in them.  Make sure

config/initializers/site_config.rb:

#
# For site defaults
#
DEFAULT_SITE_NAME = 'My Blog'
DEFAULT_TITLE = 'My Tagline'
DEFAULT_HOST = 'my.domain.tld:my_port'

#
# For Google Analytics
#
WEB_PROPERTY_ID = 'UA-XXXXXX-X'
ANALYTICS_DOMAIN = 'my.domain.tld'

#
# For shortened bit.ly links to posts
#
SiteBitly = Bitly.new('bitly_username', 'bitly_API_key')






in public/javascripts/application-config.js:

var baseURLforSite = "http://my.domain.tld:my_port/"