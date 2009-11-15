RAILS_GEM_VERSION = '2.3.4' unless defined? RAILS_GEM_VERSION

require File.join(File.dirname(__FILE__), 'boot')

AUTHORIZATION_MIXIN = "object roles"

# NOTE : If you use modular controllers like '/admin/products' be sure
# to redirect to something like '/sessions' controller (with a leading slash)
# as shown in the example below or you will not get redirected properly
#
# This can be set to a hash or to an explicit path like '/login'
#
LOGIN_REQUIRED_REDIRECTION = { :controller => '/sessions', :action => 'new' }
PERMISSION_DENIED_REDIRECTION = { :controller => '/home', :action => 'index' }

# The method your auth scheme uses to store the location to redirect back to
STORE_LOCATION_METHOD = :store_location

Rails::Initializer.run do |config|

  config.gem 'rubyist-aasm', :lib => 'aasm', :source => 'http://gems.github.com'
  config.gem 'haml', :version => '>=2.2.13'
  config.gem 'mislav-will_paginate', :lib => 'will_paginate', :version => '>=2.3.11', :source => 'http://gems.github.com'
  config.gem 'ruby-openid', :lib => 'openid', :version => '>=2.1.7'
  config.gem 'oauth', :version => '>= 0.3.6'
  config.gem 'oauth-plugin', :version => '>= 0.3.14'
  config.gem 'authlogic', :version => '>=2.1.3'
  config.gem 'authlogic-oauth', :lib => 'authlogic_oauth', :version => '>=1.0.8'
  config.gem 'syntax', :version => '>= 1.0.0'
  config.gem 'maruku', :version => '>= 0.6.0'
  config.gem "acts-as-taggable-on", :version => '>=1.0.8', :source => "http://gemcutter.org"

  config.time_zone = 'Central Time (US & Canada)'

  config.active_record.observers = :user_observer

end
