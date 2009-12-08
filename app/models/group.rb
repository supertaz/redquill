class Group < ActiveRecord::Base
  acts_as_authorizable

  has_and_belongs_to_many :users
end
