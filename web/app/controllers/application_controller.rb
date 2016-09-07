class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :filter_global_user_instance

  def filter_needs_admin_role
    if !current_user || !current_user.has_role?(:admin)
      redirect_to "/"
      return
    end
  end

  def filter_needs_race_director_role
    if !current_user
      redirect_to "/"
      return
    end

    if !current_user.has_role?(:admin) && !current_user.has_role?(:race_director)
      redirect_to "/"
      return
    end
  end

  def filter_global_user_instance
    @current_user = current_user
  end
end
