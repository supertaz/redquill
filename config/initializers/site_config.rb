#
# For site defaults
#
DEFAULT_SITE_NAME = 'Test Blog'
DEFAULT_TITLE = 'A Blog'
DEFAULT_HOST = 'localhost:3000'

#
# For Google Analytics
#
WEB_PROPERTY_ID = 'UA-000000-1'
ANALYTICS_DOMAIN = 'my.domain.tld'

#
# For shortened bit.ly links to posts
#
SiteBitly = Bitly.new('mysite', 'mykey')

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