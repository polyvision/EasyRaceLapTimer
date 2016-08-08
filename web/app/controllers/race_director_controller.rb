class RaceDirectorController < ApplicationController
  before_action :filter_needs_race_director_role

  def index
    @race_session_prototype = RaceSession.new
    @custom_soundfiles = CustomSoundfile.order("title ASC")

    @current_race_session = RaceSession::get_open_session
    @current_race_session_adapter = RaceSessionAdapter.new(@current_race_session) if @current_race_session

    @current_race_event = RaceEvent.where(active: true).first
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

  def start_next_race_event_race
    @current_race_event = RaceEvent.where(active: true).first
    if @current_race_event
      adapter = RaceEventRaceSessionBuilderAdapter.new(@current_race_event)
      if !adapter.perform
        flash[:error]= "starting a new race failed: #{adapter.error}"
      end
    end
    redirect_to action: 'index'
  end

  def stop_race_event_race
    RaceSession::stop_open_session
    redirect_to action: 'index'
  end

  def start_next_race_event_heat
    @current_race_event = RaceEvent.where(active: true).first
    if @current_race_event
      @current_race_event.next_heat
    end
    redirect_to action: 'index'
  end
end
