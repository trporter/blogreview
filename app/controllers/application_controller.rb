class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def authenticate_user!
    redirect_to new_session_path, notice: "Please Sign In" unless user_signed_in?
  end

  def user_signed_in?
    current_user.present?
  end
  helper_method :user_signed_in?

  def current_user
    @current_user ||= User.find_by_id session[:user_id]
  end
  helper_method :current_user

  def current_post
    @current_post ||= Post.find params[:post_id]
  end

  def sign_in(user)
    session[:user_id] = user.id
  end

  def current_uri
    request.env['PATH_INFO']
  end
end
