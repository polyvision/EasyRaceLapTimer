class RaceDirectorController < ApplicationController
  before_action :authenticate_user!

  def index
    @race_session_prototype = RaceSession.new
    @custom_soundfiles = CustomSoundfile.order("title ASC")

    @current_race_session = RaceSession::get_open_session
    @current_race_session_adapter = RaceSessionAdapter.new(@current_race_session) if @current_race_session
  end

  def invalidate_lap
    @pilot_race_lap = PilotRaceLap.find(params[:lapid])
    @pilot_race_lap.mark_invalidated
    flash[:notice] = t("messages.invalidated_successfully")
    redirect_to request.referer
  end

  def undo_invalidate_lap
    @pilot_race_lap = PilotRaceLap.find(params[:lapid])
    @pilot_race_lap.undo_invalidated
    flash[:notice] = t("messages.undo_invalidation_successfully")
    redirect_to request.referer
  end

  def lap_times
    @current_race_session = RaceSession::get_open_session
    @current_race_session_adapter = RaceSessionAdapter.new(@current_race_session) if @current_race_session
    render layout: false
  end
end
