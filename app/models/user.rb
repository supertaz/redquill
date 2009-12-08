class User < ActiveRecord::Base
  before_save :clean_fields

  has_and_belongs_to_many :groups
  has_many :opinions

  # For authlogic:
  acts_as_authentic

  # For rails-authorization-plugin:
  acts_as_authorized_user
  acts_as_authorizable

  #For acts-as-taggable-on:
  acts_as_tagger

  #For gravtastic:
  is_gravtastic

  validates_presence_of :firstname
  validates_length_of :firstname, :in => 2..32
  validates_presence_of :lastname
  validates_length_of :lastname, :in => 2..32
  validates_presence_of :email
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  validates_uniqueness_of :email
  validates_presence_of :nickname
  validates_length_of :nickname, :in => 2..32
  validates_presence_of :username
  validates_uniqueness_of :username
  validates_length_of :username, :in => 6..32

  def to_param
    username
  end

  private

  def clean_fields
    if self.firstname_changed?
      self.firstname = Sanitize.clean(self.firstname)
    end
    if self.lastname_changed?
      self.lastname = Sanitize.clean(self.lastname)
    end
    if self.nickname_changed?
      self.nickname = Sanitize.clean(self.nickname)
    end
    if self.email_changed?
      self.email = Sanitize.clean(self.email)
    end
    if self.twitter_username_changed?
      self.twitter_username= Sanitize.clean(self.twitter_username.gsub(/^\W/,''))
    end
    if self.user_url_changed?
      self.user_url = Sanitize.clean(self.user_url.gsub(/^\w+:\/\//, '').gsub(/(\w)\/$/, '\1'))
    end
  end
end
