class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      sign_in(@user)
      redirect_to posts_path, notice: "Signed Up!"
    else
      render :new
    end
  end

  def edit
    @user = User.find params[:id]
  end

  def update
    @user = User.find(params[:id])
    if @user.update user_params
      redirect_to users_path(@user), notice: "Info Updated"
    else
      render :edit
    end
  end

  def index
    @user = current_user
  end

  private

  def user_params
    user_params = params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end
end
