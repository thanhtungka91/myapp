class UsersController < ApplicationController

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
    else
      render 'edit'
  end
  private
  def user_params
    return params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end