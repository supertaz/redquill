class ApplicationController < ActionController::Base
  protect_from_forgery
  filter_parameter_logging :password

  helper_method :current_user
  helper_method :page_title
  helper_method :owner_user
  helper_method :redirect_back_or_default
  helper_method :store_location
  helper_method :require_user
  helper_method :require_no_user

private

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end

  def owner_user
    Group.find_by_name('Owner').users.first
  end

  def page_title(new_title = nil)
    @page_title = "#{DEFAULT_SITE_NAME} - #{new_title.nil? ? DEFAULT_TITLE : new_title}"
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

  def store_location
    if request.get?
      session[:return_to] = request.request_uri
    else
      session[:return_to] = request.referrer unless request.xhr?
    end
  end

  def require_user
    unless current_user
      store_location
      flash[:notice] = "You must be logged in to access this page"
      redirect_to new_user_session_url
      return false
    end
  end

  def require_no_user
    if current_user
      store_location
      flash[:notice] = "You must be logged out to access this page"
      redirect_to user_url(current_user)
      return false
    end
  end

end
