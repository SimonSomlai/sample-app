class SessionsController < ApplicationController
  def new
    # Only used for template rendering
  end

  def create
    # When session form is send to sessions#create, find the email of the user in the nested hash.
    user = User.find_by(email: params[:session][:email].downcase)
    # If the email matches one in the db and the password matches
    if user && user.authenticate(params[:session][:password])
      # is this user activated?
      if user.activated?
        # create session in the browser
        login user
        # if remember is true, create permanent remember_token cookie in the browser & sets remember_digest for user
        # else remove the cookies & digest
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        redirect_back_or home_path
        flash[:success] = "Welcome back #{user.name}!"
      else
        flash[:warning] = "Account not activated, check your mail for the activation link."
        redirect_to home_path
      end
    else
      flash.now[:danger] = "Incorrect email and password combination"
      render :new
    end
  end

  def destroy
    logout if logged_in?
    redirect_to home_path
  end

end
