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
      SoundFileWorker.perform_async("sfx_start_race")
    end

    redirect_to action: 'index', controller: '/race_director'
  end

  def stop_race_session
    @race_session = RaceSession::get_open_session
    if @race_session
      @race_session.update_attribute(:active,false)
      @race_session.update_attribute(:idle_time_in_seconds,0) # this one is important! otherwise the system will automaticly clone it.... so you won't be able to stop a session ;)
    end
    redirect_to action: 'index', controller: '/race_director'
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

  def shutdown
    load "#{Rails.root}/lib/ir_daemon_cmd.rb"
    IRDaemonCmd::send("SHUTDOWN#\n")
    redirect_to action: 'index'
  end

  private

  def get_style_settings
    @style_setting = StyleSetting.where(id: 1).first_or_create
  end

  def strong_params_race_session
    params.require(:race_session).permit(:title,:idle_time_in_seconds)
  end

  def strong_params_style_settings
    params.require(:style_setting).permit(:own_logo_image)
  end
end
