class ApplicationController < ActionController::Base
  before_filter :current_user

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private
  def current_user
    @current_user ||= User.find_by_id(session[:user_id])
    @current_user_by_token = User.find_by(:auth_token => request.headers["Authorization"])
  end

end

