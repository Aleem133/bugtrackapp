class ApplicationController < ActionController::Base

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:username, :email, :password, :usertype)}

    devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:username, :email, :password, :usertype, :current_password)}
  end

  def require_user
    if current_user
        @user = current_user
    else
        redirect_to new_user_session_path, notice: 'You are not logged in.'
    end
  end
end
