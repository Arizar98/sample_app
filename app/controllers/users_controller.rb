class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(new create show)
  before_action :correct_user, only: [:edit, :update]

  def index
    @users = User.page(params[:page]).per(30)
  end

  def destroy
    User.find_by(id: params[:id]).destroy
    flash[:success] = t "user_deleted"
    redirect_to users_url
  end

  def show
    @user = User.find_by id: params[:id]
    @microposts = @user.microposts.paginate(page: params[:page])
    return if @user
    flash[:warning] = "User not found"
    redirect_to root_path
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render :new
      flash.now[:alert] = t ".try_again"
    end
  end

  def edit
    @user = User.find_by id: params[:id]
  end

  def update
    @user = User.find_by id: params[:id]
    if @user.update_attributes user_params
      flash[:success] = t "profile_update"
      redirect_to @user
    else
      render "edit"
    end
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render "show_follow"
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render "show_follow"
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password, :password_confirmation
  end

  # Confirms the correct user.
  def correct_user
    @user = User.find_by id: params[:id]
    redirect_to(root_url) unless current_user?(@user)
  end

end
