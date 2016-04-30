class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception
    include Pundit
    include Users::SessionsHelper

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def require_sign_in
    unless current_user
      flash[:alert] = "You must be logged in to do that"
      redirect_to new_user_session_path
    end
  end

  def user_not_authorized exception
    flash[:alert] = "You are not authorized to do that."
    redirect_to(request.referrer || root_path)
  end

end
