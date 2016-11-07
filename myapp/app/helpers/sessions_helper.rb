# all class for session only
module SessionsHelper
  def log_in(user)
    puts 'Login la save thang id vao trong session-> khong dung y nghia cho lam:D '
    session[:user_id] = user.id
  end

  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: session[:user_id])
    elsif(user_id = cookies.signed[:user_id])
      user = User.find(id: user_id)
      if user && user.authenticated?(:remember, cookies[:remember_token])
        log_in user
        @current_user = user
      end

    end


  end

  def logged_in?
    !current_user.nil?
  end
  # check current user is correct or not -> apply when you edit user
  def current_user?(user)
    user == current_user
  end

  def log_out
    # same class thi cu goi thoi -> forget function phai truyen nguoi vao -> do la nguoi hien tai
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end
  # refer this link for understand of cookie
  # http://api.rubyonrails.org/classes/ActionDispatch/Cookies.html
  def remember(user)
    # create random token-> save to remember digest to database
    # save id and rember_token
    # sau nay se lay cai thang remember token -> encryt -> rember_digest -> understand
    user.remember
    # Sets a "permanent" cookie (which expires in 20 years from now).
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end
  # thang session se goi ve thang model -> set digest to nil and delete session
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end
# problem
  #if user wants to go to edit but they are not logged-> they will direct login site-> after loggin -> \
  # as normal-> it only go to the link show -> not edit -->
  #==> we should save the link save -> after loing -> back the edit page
  #save the url -> user wants to go
  def store_location
    puts('request!!!!!!!!!', request)
    session[:forwarding_url] = request.original_url if request.get?
  end
  # back to forwarding_url
  # minh van chua hieu default o day dung nhu the nao nua
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end
end
