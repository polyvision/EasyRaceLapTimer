class SystemController < ApplicationController
  before_action :authenticate_user!

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

  private

  def strong_params_race_session
    params.require(:race_session).permit(:title)
  end
end
