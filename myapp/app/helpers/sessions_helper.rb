module SessionsHelper
  def log_in(user)
    puts 'here is helppppp, what is the isuse? '
    session[:user_id] = user.id
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end
end