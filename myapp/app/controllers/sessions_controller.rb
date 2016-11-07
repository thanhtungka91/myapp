class SessionsController < ApplicationController
  def new
  end

  def create
    puts('Ham nay thuc ra la mot ham login-> lay param tu form->login->save session')
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      if user.activated?
        log_in user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        redirect_back_or user
      else
        message  = "Account not activated. "
        message += "Check your email for the activation link."
        flash[:warning] = message
        redirect_to root_url
      end
    else
      # Create an error message.
      puts 'hello'
      flash[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    #if the user is logged_in -> logout
    log_out if logged_in?
    redirect_to root_url

  end
end
