class Comment < ActiveRecord::Base
  belongs_to :post, :counter_cache => true
  belongs_to :commenter, :class_name => 'User'
  before_save :prepare_save

  attr_readonly :seqno

  private

  def prepare_save
    if self.seqno.nil?
      self.seqno = self.post.comments_count + 1
    end
  end
end
