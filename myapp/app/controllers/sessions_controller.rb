class SessionsController < ApplicationController
  def new
  end

  def create
    puts('create o day la create session chu khong lien quan gi den user!!!!!!!!!!!!!!!!!!!!!!!!!!!!')
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # inpuet user infor to session
      log_in user
      # if the user click to remember_me -> save user else -forget user
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      # check if in session has a fowarding_url ->directo link else -> defaul user
      redirect_back_or user
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
