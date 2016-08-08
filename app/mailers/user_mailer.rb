class UserMailer < ApplicationMailer
  
  def account_activation(user)
    @user = user
    @greeting = "Hi #{@user.name}"
    mail to: @user.email, subject: "Account Activation (& Magic Unicorns)"
  end

  def password_reset(user)
  	@user = user
    @greeting = "Hi #{@user.name}"
    mail to: @user.email, subject: "Password Reset (& Secrets Of The Universe)"
  end
end
