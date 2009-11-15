class User < ActiveRecord::Base
  # For authlogic:
  acts_as_authentic

  # For rails-authorization-plugin:
  acts_as_authorized_user
  acts_as_authorizable

  #For acts-as-taggable-on:
  acts_as_tagger
end
