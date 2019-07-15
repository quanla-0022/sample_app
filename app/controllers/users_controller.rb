class UsersController < ApplicationController
  before_action :load_user, except: %i(index new create)
  before_action :logged_in_user, except: %i(new create show)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: %i(destroy)

  def index
    @users = User.ordered_by_name.page params[:page]
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params

    if @user.save
      @user.send_activation_email
      flash[:info] = t "check_email_notice"
      redirect_to root_url
    else
      render :new
    end
  end

  def show
    @microposts =
      Kaminari
      .paginate_array(@user.microposts.ordered_by_create_at)
      .page(params[:page])
      .per Settings.per_page
  end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t "updated"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "delete_user"
    else
      flash.now[:notice] = t "user_deleted_failed"
    end
    redirect_to users_url
  end

  def following
    @title = t "following"
    @users = @user.following.page params[:page]
    render :show_follow
  end

  def followers
    @title = t "followers"
    @users = @user.followers.page params[:page]
    render :show_follow
  end

  private

  def load_user
    @user = User.find_by id: params[:id]
    return if @user
    flash[:danger] = t "user_not_found"
    redirect_to root_path
  end

  def user_params
    params.require(:user)
          .permit :name, :email, :password, :password_confirmation
  end

  def correct_user
    return if current_user?(@user)
    flash[:danger] = t "not_current_user"
    redirect_to root_url
  end

  def admin_user
    return if current_user.admin?
    flash[:danger] = t "not_admin"
    redirect_to root_url
  end
end
