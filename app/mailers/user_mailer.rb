class UserMailer < ApplicationMailer

  default from: "edwrdwalsh@gmail.com"

  def new_user(user)

    @user = user

    mail(to: user.email, subject: "New user on Blocipedia")
  end

end
