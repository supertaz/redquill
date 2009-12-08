class Opinion < ActiveRecord::Base
  belongs_to :user
  belongs_to :comment

  named_scope :user, lambda { |user| {:conditions => "user_id = #{user.id}"}}
  named_scope :comment, lambda { |comment| {:conditions => "comment_id = #{comment.id}"}}

end
