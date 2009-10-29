class UserSession < Authlogic::Session::Base
  consecutive_failed_logins_limit 4
  failed_login_ban_for(4.hours)

  def self.oauth_consumer
    OAuth::Consumer.new("TOKEN", "SECRET",
    { :site => "http://authpoint.com",
      :authorize_url => "http://authpoint.com/oauth/authenticate"})
  end

end
