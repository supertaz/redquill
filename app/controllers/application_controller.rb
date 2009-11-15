class ApplicationController < ActionController::Base
  protect_from_forgery
  filter_parameter_logging :password

  helper_method :current_user
  helper_method :page_title
  helper_method :tags_for_cloud

private

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end

  def page_title(new_title = nil)
    unless new_title.nil?
      @page_title = new_title
    else
      @page_title
    end
  end

  def tags_for_cloud
    Post.tag_counts_on(:tags)
  end
end
