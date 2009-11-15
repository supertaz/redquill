class Post < ActiveRecord::Base
  belongs_to :poster, :class_name => 'User'
  has_many :comments, :include => :commenter

  acts_as_taggable_on :tags

  before_save :prepare_save

  attr_readonly :comments_count 
  attr_readonly :title_hash

  named_scope :by_age, {:order => "posts.id DESC"}
  named_scope :by_slug, lambda { |slug| {:conditions => ["title_hash = ?", Digest::MD5.hexdigest(slug)]}}
  named_scope :by_slug_and_date, lambda { |slug, year, month, day|
                    {
                            :conditions => [
                                    "title_hash = ?
                                     AND local_date = ?",
                                     Digest::MD5.hexdigest(slug),
                                     "#{year}-#{month}-#{day}"
                            ]
                    }
  }

  def slug
    self.title.gsub(/^\W*/, '').gsub(/\W*$/, '').gsub(/\W+/, '-')
  end

  def write_attribute(attr_name, value)
    returning(super) do
      if attr_name == 'title'
        self.title_hash = Digest::MD5.hexdigest(value.gsub(/^\W*/, '').gsub(/\W*$/, '').gsub(/\W+/, '-'))
      end
    end
  end

  def split_date
    
  end

  private

  def prepare_save
#    if self.comments_count.nil?
#      self.comments_count = 0
#    end
#    if self.title_hash.nil?
#      self.title_hash = Digest::MD5.hexdigest(self.title.strip.gsub(/,/, '').gsub(/\W/, '-'))
#    end
    if self.local_date.nil?
      now = DateTime::now()
      self.local_date = "#{now.year}-#{now.month.to_s.rjust(2, '0')}-#{now.day.to_s.rjust(2, '0')}"
    end
  end
end
