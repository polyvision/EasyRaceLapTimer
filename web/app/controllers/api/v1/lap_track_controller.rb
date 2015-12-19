class Api::V1::LapTrackController < Api::V1Controller
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

    # min lap time
    min_t = ConfigValue::get_value("lap_min_lap_time_in_seconds").value.to_f * 1000.0
    if params[:lap_time_in_ms].to_f < min_t
      render status: 403, text: "NOT TRACKED: request successfull but lap time was less than min lap time: #{min_t} t: #{params[:lap_time_in_ms].to_f}"
      return
    end

    # max lap time
    max_t = ConfigValue::get_value("lap_max_lap_time_in_seconds").value.to_f * 1000.0
    if params[:lap_time_in_ms].to_f >= max_t
      render status: 403, text: "NOT TRACKED: request successfull but lap time reached max lap time max: #{max_t} t: #{params[:lap_time_in_ms].to_f}"
      return
    end

    begin
      race_session_adapter = RaceSessionAdapter.new(@race_session)
      pilot_race_lap = race_session_adapter.track_lap_time(params[:transponder_token],params[:lap_time_in_ms])
    rescue Exception => ex
      render status: 403, text: "#{ex.message}\n#{ex.backtrace.join("\n")}"
      return
    end

    render json: pilot_race_lap.to_json
  end

  private
end
