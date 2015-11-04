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

    @pilot = Pilot.where(transponder_token: params[:transponder_token]).first
    if !@pilot
      render status: 409, text: "no registered pilot with the transponder token #{params[:transponder_token]}"
      return
    end

    pilot_race_lap = @race_session.add_lap(@pilot,params[:lap_time_in_ms])

    ActionCable.server.broadcast 'monitor_notifications',type: "updated_stats"

    render json: pilot_race_lap.to_json
  end

  private
end
