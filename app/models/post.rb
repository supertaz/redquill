class Post < ActiveRecord::Base
  include ActionController::UrlWriter

  validates_presence_of :title
  validates_uniqueness_of :title

  validates_presence_of :body

  belongs_to :poster, :class_name => 'User'
  has_many :comments, :include => :commenter

  acts_as_taggable_on :tags

  attr_readonly :comments_count 
  attr_readonly :title_hash

  named_scope :drafts, lambda { |poster| {:conditions => ["posts.draft = 't' AND posts.poster_id = ?", poster.id], :order => "posts.id ASC"}}
  named_scope :all_drafts, {:conditions => ["posts.draft = 't'"], :order => "posts.id ASC"}
  named_scope :in_list, lambda{ |list| {:conditions => ["posts.id in (#{list})"]}}
  named_scope :by_age, {:conditions => ["posts.draft = 'f'"], :order => "posts.id DESC"}
  named_scope :recent, {:conditions => ["posts.draft = 'f'"], :order => "posts.id DESC", :limit => 10}
  named_scope :by_year, lambda { |year| {:conditions => ["posts.draft = 'f' AND local_date like '#{year}-%%'"], :order => "posts.id DESC", :include => [:poster, :tags, :comments]}}
  named_scope :by_month, lambda { |year, month|
                    {
                            :conditions => [
                                    "posts.draft = 'f'
                                     AND local_date like '#{year}-#{month.to_s.rjust(2, '0')}-%%'"
                            ],
                            :order => "posts.id DESC", 
                            :include => [:poster, :tags, :comments]
                    }
  }
  named_scope :by_slug, lambda { |slug|
                    {
                            :conditions => [
                                    "posts.draft = 'f' AND title_hash = ?",
                                    Digest::MD5.hexdigest(slug)
                            ],
                            :include => [:poster, :tags, :comments]
                    }
  }
  named_scope :by_date, lambda { |year, month, day|
                    {
                            :conditions => [
                                    "posts.draft = 'f'
                                     AND local_date like '#{year}-#{month.to_s.rjust(2, '0')}-#{day.to_s.rjust(2, '0')}'"
                            ],
                            :order => "posts.id DESC",
                            :include => [:poster, :tags, :comments]
                    }
  }
  named_scope :by_slug_and_date, lambda { |slug, year, month, day|
                    {
                            :conditions => [
                                    "posts.draft = 'f'
                                     AND title_hash = ?
                                     AND local_date = ?",
                                     Digest::MD5.hexdigest(slug),
                                     "#{year}-#{month.to_s.rjust(2, '0')}-#{day.to_s.rjust(2, '0')}"
                            ]
                    }
  }

  def slug
    self.title.gsub(/^\W*/, '').gsub(/\W*$/, '').gsub(/\W+/, '-')
  end

  def write_attribute(attr_name, value)
    returning(super) do
      case attr_name
        when 'title'
          self.title_hash = Digest::MD5.hexdigest(value.gsub(/^\W*/, '').gsub(/\W*$/, '').gsub(/\W+/, '-'))
      end
    end
  end

  def publish!
    now = Time.zone.now
    self.local_date = "#{now.year}-#{now.month.to_s.rjust(2, '0')}-#{now.day.to_s.rjust(2, '0')}"
    self.published_at = now
    self.short_url=SiteBitly.shorten(self.permanent_url).short_url
    self.save
  end

  def unpublish!
    self.local_date = nil
    self.published_at = nil
    self.short_url = nil
    self.save
  end

  def self.counts_by_year
    years = Hash.new
    start = Post.by_age.last.published_at.year
    Time.zone.now.year.downto(start).each do |year|
      years[year.to_s] = Post.by_year(year).count
    end
    years
  end

  def self.counts_by_month
    months = Array.new
    unless Post.count == 0
      startyear = Post.by_age.last.published_at.year
      yearcount = 0
      Time.zone.now.year.downto(startyear).each do |year|
        months[yearcount] = {year => [Post.by_year(year).count]}
        12.downto(1) do |month|
          count = Post.by_month(year, month).count
          months[yearcount][year][13 - month] = {DateTime::MONTHNAMES[month] => count}
        end
        yearcount += 1
      end
    end
    months
  end

  def permanent_url
    show_posts_url(:host => DEFAULT_HOST, :year => self.published_at.year, :month => self.published_at.month, :day => self.published_at.day, :slug => self.slug)
  end

  private

end
