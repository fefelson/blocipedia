class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include Pundit
  include Users::SessionsHelper

  # Throw exception if controller action does not have authorization method https://github.com/elabs/pundit#ensuring-policies-and-scopes-are-used
  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index

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

    if exception.query == "edit?" || exception.query == "update?"
      redirect_to user_path(current_user)

    elsif exception.query == "show?"
      unless user_signed_in?
        redirect_to new_user_session_path
      else
        redirect_to user_path(current_user)
      end

    elsif exception.query == "create?"
      redirect_to user_path(current_user)

    elsif exception.query == "destroy?"
      redirect_to :back
    end
  end

end
