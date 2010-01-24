In order for this application to work properly, there are two files that you need to create, with the following defined
in them.  Make sure you do these, otherwise you won't get the results you're expecting (in fact, everything will break).

Also, you need to set a secret session key in config/initializers/session_store.rb if you don't want your sessions hacked.

FILES:




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

#
# For sending emails
#

ActionMailer::Base.smtp_settings = {
  :address => "smtp.test.com",
  :port => 587,
  :authentication => :plain,
  :enable_starttls_auto => true,
  :user_name => "test@test.com",
  :password => "testpass"
}

#
# For ReCaptcha plugin, which expects ENV variables
#

ENV['RECAPTCHA_PUBLIC_KEY']  = 'mypublickey'
ENV['RECAPTCHA_PRIVATE_KEY'] = 'mysecretkey'




in public/javascripts/application-config.js:

var baseURLforSite = "http://my.domain.tld:my_port/"