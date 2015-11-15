class SystemController < ApplicationController
  before_action :authenticate_user!
  before_action :get_style_settings

  def index
    @race_session_prototype = RaceSession.new
  end

  def start_race_session
    if !RaceSession::get_open_session
      @race_session = RaceSession.new(strong_params_race_session)
      @race_session.active = true
      @race_session.save
    end

    redirect_to action: 'index'
  end

  def stop_race_session
    @race_session = RaceSession::get_open_session
    if @race_session
      @race_session.update_attribute(:active,false)
    end
    redirect_to action: 'index'
  end

  def update_style
    @style_setting.update_attributes(strong_params_style_settings)
    redirect_to action: 'index'
  end

  def set_config_val
    c = ConfigValue.where(id: params[:id]).first
    c.update_attribute(:value,params[:value])
    redirect_to action: 'index'
  end

  private

  def get_style_settings
    @style_setting = StyleSetting.where(id: 1).first_or_create
  end

  def strong_params_race_session
    params.require(:race_session).permit(:title)
  end

  def strong_params_style_settings
    params.require(:style_setting).permit(:own_logo_image)
  end
end
