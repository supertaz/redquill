class Comment < ActiveRecord::Base
  belongs_to :post, :counter_cache => true, :touch => true
  belongs_to :commenter, :class_name => 'User'
  before_save :prepare_save

  has_many :opinions

  named_scope :last_updated_by_post_id, lambda {|post_id| {:conditions => "comments.post_id = #{post_id}", :order => 'updated_at DESC'}}

  attr_readonly :seqno

  def agree(user)
    if self.opinions.user(user).count == 0
      self.agreed += 1
      self.save
      self.opinions.create(:user_id => user, :comment_id => self.id, :agreed => true)
    else
      opinion = self.opinions.user(user).first
      unless opinion.agreed?
        self.agreed +=  1
        self.disagreed = self.disagreed - 1
        self.save
        opinion.agreed = true
        opinion.save
      end
    end
  end

  def disagree(user)
    if self.opinions.user(user).count == 0
      self.disagreed += 1
      self.save
      self.opinions.create(:user_id => user.id, :comment_id => self.id, :agreed => false)
    else
      opinion = self.opinions.user(user).first
      if opinion.agreed?
        self.agreed = self.agreed - 1
        self.disagreed += 1
        self.save
        opinion.agreed = false
        opinion.save
      end
    end
  end

  private

  def prepare_save
    if self.seqno.nil? || self.seqno == 0
      self.seqno = self.post.comments_count + 1
    end
    self.title = Sanitize.clean(self.title)
    self.body = Sanitize.clean(self.body)
  end
end
