class Post < ActiveRecord::Base
  belongs_to :user
  
  attr_readonly :comments_count
end
