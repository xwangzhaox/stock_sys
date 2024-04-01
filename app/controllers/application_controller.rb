class ApplicationController < ActionController::Base
  protect_from_forgery prepend: true
  before_action :authenticate_user!
  load_and_authorize_resource :unless => :devise_controller?
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_current_user
  before_action :store_location

  protected
  def set_current_user
    User.current_user = current_user
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email])
    devise_parameter_sanitizer.permit(:sign_in, keys: [:login, :password])
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message #導向另一個頁面
  end

  def after_sign_in_path_for(resource)
    current_user.username.blank? ? root_path(current_user) : redirect_back_or(dashboard_index_path)
  end

  def redirect_back_or(default)
    return_to = session[:return_to] || default
    session.delete(:return_to)
    return_to
  end

  def store_location
    session[:return_to] = request.fullpath unless user_signed_in?
  end
end
