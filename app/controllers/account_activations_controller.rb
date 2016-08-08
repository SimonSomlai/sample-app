class AccountActivationsController < ApplicationController
  def edit
  	# Link looks like this: http://localhost:3000/account_activations/XHgbHb0-9JQLUC2G1OmHuQ/edit?email=kaka%40hotmail.com
  	# Token can be accessed through params[:id] & email is an extra attribute given through the email params[:email]
    user = User.find_by(email: params[:email])
    # if the user can be found and is inactivated, authenticate the activation_digest (made before creation) with the current token
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      flash[:success] = "Account successfully activated! - welcome #{user.name}!"
      login user
      redirect_to user
    else
      flash[:danger] = "Invalid activation link or email"
      redirect_to home_path
    end
  end
end
