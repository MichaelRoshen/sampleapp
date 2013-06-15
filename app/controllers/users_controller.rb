class UsersController < ApplicationController

  #没有登录的用户，访问修改，更新，查看页面，重定向到首页
  before_filter :signed_in_user, only: [:index, :edit, :update, :show]
  #当前用户不能修改，更新，查看他人信息
  before_filter :correct_user, only: [:edit, :update, :show]
  #非管理员访问destroy，重定向到首页
  before_filter :admin_user, only: [:destroy]
  #已经登录的用户不能再访问创建用户页面，重定向到首页
  before_filter :had_sign_in, only: [:new,:create]

  def index
    @users = User.paginate(page: params[:page], per_page: 8)
  end
  def new
    @user = User.new
  end
  
  def show
    #访问show的时候，会先调用过滤器correct_user，返回@user
    @microposts = @user.microposts.paginate(page: params[:page])
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

  def destroy
    @user = User.find(params[:id])
    if @user.admin?
      flash[:error] = "can't delete admin"
    else
      flash[:success] = "User destroyed"
      @user.destroy
    end
    redirect_to users_path
  end

  private
  

  def correct_user
    #before_filter :correct_user在访问show, edit ,update 控制器的时候会调用correct_user
    #这里统一返回@user变量，show, edit ,update中的@user = User.find(params[:id])就可以去掉了
    @user = User.find(params[:id])
    redirect_to(root_path) unless current_user?(@user)
  end

  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end

  def had_sign_in
    redirect_to(root_path) if signed_in?
  end
end
