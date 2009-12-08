class ApplicationController < ActionController::Base
  protect_from_forgery
  filter_parameter_logging :password

  helper_method :current_user
  helper_method :page_title
  helper_method :owner_user
  helper_method :redirect_back_or_default
  helper_method :store_location

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
    unless new_title.nil?
      @page_title = new_title
    else
      @page_title
    end
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

  def store_location
    session[:return_to] = request.request_uri
  end

end
