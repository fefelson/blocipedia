class Users::RegistrationsController < Devise::RegistrationsController

  skip_after_action(:verify_authorized, :verify_policy_scoped)

  def new
    @user = User.new
  end

  def create
    @user = User.new
    @user.name = params[:user][:name]
    @user.email = params[:user][:email]
    @user.password = params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation]
    @user.role = :standard

    if @user.save
      flash[:notice] = "Welcome to Blocipedia #{@user.name}!"
      sign_in(@user)
      redirect_to root_path

    else
      flash.now[:alert] = "There was an error creating your account.  Please try again."
      render :new
    end
  end

end
