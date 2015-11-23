class Api::V1::LapTrackController < Api::V1Controller
  protect_from_forgery except: :create

  def create

    @race_session =  RaceSession::get_open_session

    # there's no active race session
    if !@race_session
      render status: 409, text: 'no running race session'
      return
    end

    if params[:transponder_token].blank? || params[:lap_time_in_ms].blank?
      render status: 409, text: "one or more tracking params are blank: #{params.inspect}"
      return
    end

    # max lap time
    if params[:lap_time_in_ms].to_f >= (ConfigValue::get_value("lap_max_lap_time_in_seconds").value.to_f * 1000.0)
      render status: 403, text: 'request successfull but lap time reached max lap time'
      return
    end

    @pilot = Pilot.where(transponder_token: params[:transponder_token]).first
    if !@pilot
      render status: 409, text: "no registered pilot with the transponder token #{params[:transponder_token]}"
      return
    end

    # check if the lap tracking was too fast
    last_track = @race_session.pilot_race_laps(pilot_id: @pilot.id).order("ID DESC").first
    if last_track && last_track.created_at + ConfigValue::get_value("lap_timeout_in_seconds").value.to_i.seconds > Time.now
      render status: 403, text: 'request successfull but tracking was too fast concering the last track'
      return
    end

    pilot_race_lap = @race_session.add_lap(@pilot,params[:lap_time_in_ms])
    Soundfile::play("sfx_lap_beep")
    begin
      ActionCable.server.broadcast 'monitor_notifications',type: "updated_stats"
    rescue Exception => ex
      logger.fatal(ex.message)
      logger.fatal(ex.backtrace.join("n"))
    end

    render json: pilot_race_lap.to_json
  end

  private
end
