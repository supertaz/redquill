#
# For site defaults
#
DEFAULT_SITE_NAME = 'RedEarth'
DEFAULT_TITLE = 'A RedQuill Blog'
DEFAULT_TAGLINE = 'A blog powered by RedQuill'
BLOG_OWNER_NAME = 'Joe Blogger'
BLOG_ORIGIN_YEAR = 2010
DEFAULT_HOST = 'localhost:3000'
DEFAULT_MULTI_POST_TITLE = 'In my own words'
DEFAULT_SINGLE_POST_TITLE = 'What I\'m saying is'

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