class UsersController < ApplicationController

  before_action :require_sign_in
  skip_after_action(:verify_authorized, :verify_policy_scoped)

  def show
    @user = User.find(params[:id])
  end

  def downgrade
    @user = User.find(params[:id])
    if @user.downgrade!
      flash[:notice] = "something"
    else
      flash[:error] = "something else"
    end
    redirect_to :back
  end


end
