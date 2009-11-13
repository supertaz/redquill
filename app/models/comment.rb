class Comment < ActiveRecord::Base
  belongs_to :post, :counter_cache => true
  belongs_to :commenter, :class_name => 'User'
end
