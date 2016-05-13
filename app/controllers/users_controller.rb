class UsersController < ApplicationController

  before_action :require_sign_in
  skip_after_action(:verify_authorized, :verify_policy_scoped)

  def show
    @user = User.find(params[:id])
  end

  def downgrade
    @user = User.find(params[:user_id])
    @user.standard!
    Wiki.where({user_id: @user.id}).find_each do |wiki|
      wiki.public!
    end

    redirect_to :back
  end


end
