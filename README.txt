Some history
============

Please note that this project started off as a simple example for rails newbies, largely as a practice-what-you-preach
exercise.  In helping countless people get started with Rails, one of the first projects I (and other Rails developers)
recommend is to create a simple blog.  As I incorporated more and more examples into the platform, I decided to do two
things:

1) Open-source the platform as an example
2) Add code coverage that's sorely lacking

#1 is done (obviously), but #2 is moving very slowly, as my closed-source client projects take precedence.  If you'd
like to contribute cucumber or RSpec tests to this project, please send a pull request -- I'm very happy to have
help, and it's a great way for you to learn about these testing frameworks and BDD.



Installation
============

In order for this application to work properly, there are two files that you need to create, with the following defined
in them.  Make sure you create these and fill in the appropriate fields, otherwise you won't get the results you're
expecting (in fact, everything will break).

Also, you need to set a secret session key in config/initializers/session_store.rb if you don't want your sessions hacked.

FILES:




config/initializers/site_config.rb:

#
# For site defaults
#
DEFAULT_SITE_NAME = 'A RedQuill Blog'
DEFAULT_TITLE = 'A RedQuill Blog'
DEFAULT_TAGLINE = 'A blog powered by RedQuill'
BLOG_OWNER_NAME = 'Joe Blogger'
BLOG_ORIGIN_YEAR = 2010
DEFAULT_HOST = 'my.domain.tld'
DEFAULT_MULTI_POST_TITLE = 'In my own words'
DEFAULT_SINGLE_POST_TITLE = 'What I\'m saying is'

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

var baseURLforSite = "http://my.domain.tld:my_port/";
var ownerTwitterAccount = 'twitterAccount';
