class UsersController < ApplicationController
  # this function "edit" and "update" need to check authorization
  # in here we have to implement logged_in_user

  before_action :logged_in_user, only: [:edit, :update]
  before_action :correct_user, only: [:edit, :update]

  def show
    @user = User.find(params[:id])
  end

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end
  # tuc la mac dinh la no se co roi
  # neu ma khong vut vao day thi no van chay duoc la sao nhi?
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'

    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      puts "update sucessfull"
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end
  private
  def user_params
    return params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def logged_in_user
    # if is not logged -> nguoc lai voi if
    unless logged_in?
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end

  def correct_user
  #   minh phai get id ra va so sanh neu it is NOT same id -> not
    @user = User.find(params[:id])
    unless current_user?(@user)
      redirect_to root_url
    end
  end
end