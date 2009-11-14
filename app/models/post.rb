class Post < ActiveRecord::Base
  belongs_to :poster, :class_name => 'User'
  attr_readonly :comments_count
end
