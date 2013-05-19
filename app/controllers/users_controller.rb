class UsersController < ApplicationController

  before_filter :signed_in_user, only: [:edit, :update, :show]
  before_filter :correct_user, only: [:edit, :update, :show]

  def new
    @user = User.new
  end
  
  def show
  end

  def edit
  end

  def update
    if @user.update_attributes(params[:user])
       flash[:success] = "Profile updated"
       sign_in @user
       redirect_to @user
    else
      render 'edit'
    end
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render "new"
    end
  end

  private
  
  def signed_in_user
    redirect_to signin_path, notice: "Please Sign in" unless signed_in?
  end

  def correct_user
    #before_filter :correct_user在访问show, edit ,update 控制器的时候会调用correct_user
    #这里统一返回@user变量，show, edit ,update中的@user = User.find(params[:id])就可以去掉了
    @user = User.find(params[:id])
    redirect_to(root_path) unless current_user?(@user)
  end
end
