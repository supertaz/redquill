class Post < ActiveRecord::Base
  belongs_to :poster, :class_name => 'User'
  has_many :comments, :include => :commenter

  acts_as_taggable_on :tags

  before_save :prepare_save

  attr_readonly :comments_count 
  attr_readonly :title_hash

  named_scope :by_age, {:order => "posts.id DESC"}
  named_scope :by_year, lambda { |year| {:conditions => ["local_date like '#{year}-%%'"], :order => "posts.id DESC"}}
  named_scope :by_month, lambda { |year, month| {:conditions => ["local_date like '#{year}-#{month}-%%'"], :order => "posts.id DESC"}}
  named_scope :by_slug, lambda { |slug| {:conditions => ["title_hash = ?", Digest::MD5.hexdigest(slug)]}}
  named_scope :by_date, lambda { |year, month, day| {:conditions => ["local_date like '#{year}-#{month}-#{day}'"], :order => "posts.id DESC"}}
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

  def self.counts_by_year
    years = Hash.new
    start = Post.by_age.last.local_date.gsub(/-.*-.*$/, '').to_i
    (start..DateTime::now().year).each do |year|
      years[year.to_s] = Post.by_year(year).count
    end
    years
  end

  def self.counts_by_month
    months = Hash.new
    startyear = Post.by_age.last.local_date.gsub(/-.*-.*$/, '').to_i
    (startyear..DateTime::now().year).each do |year|
      months[year] = [Post.by_year(year).count]
      monthcount = 1
      (1..12).each do |month|
        count = Post.by_month(year, month).count
        if count > 0
          months[year][monthcount] = {DateTime::MONTHNAMES[month] => count}
          monthcount = monthcount + 1
        end
      end
    end
    months
  end

  private

  def prepare_save
    if self.local_date.nil?
      now = DateTime::now()
      self.local_date = "#{now.year}-#{now.month.to_s.rjust(2, '0')}-#{now.day.to_s.rjust(2, '0')}"
    end
  end
end
