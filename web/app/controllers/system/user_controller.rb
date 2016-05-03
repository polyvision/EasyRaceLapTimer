class System::UserController < ApplicationController
  before_action :filter_needs_admin_role

  def index
    @users = User.all
  end

  def edit
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(strong_params_user)

    if !@user.save
      flash['error'] = @user.errors.full_messages
      render action: 'new'
    else
      redirect_to action: 'edit', id: @user.id
    end
  end

  def update
    @user = User.find(params[:id])

    Role.all.each do |role|
      if params[:role][role.id.to_s].to_i == 1
        @user.add_role(role.name)
      else
        @user.remove_role(role.name)
      end
    end

    # ensure that the first user is always admin!!!
    if @user.id == 1
      @user.add_role(:admin)
    end

    if !params[:user][:password].blank?
      @user.password = params[:user][:password]
      @user.password_confirmation = params[:user][:password_confirmation]
    end

    if !@user.save
      flash['error'] = @user.errors.full_messages
      render action: 'edit'
    else

      redirect_to action: :index
    end
  end

  def destroy
    @user = User.find(params[:id])

    if @user.id != 1
      @user.destroy
    end
    redirect_to action: 'index'
  end

  private

  def strong_params_user
    params.require(:user).permit(:email,:password,:password_confirmation)
  end
end
