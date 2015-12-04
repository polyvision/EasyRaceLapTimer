class Api::V1::SatelliteController < Api::V1Controller

  def create
    @race_session =  RaceSession::get_open_session

    # there's no active race session
    if !@race_session
      render status: 409, text: 'no running race session'
      return
    end

    if params[:transponder_token].blank?
      render status: 409, text: "one or more tracking params are blank: #{params.inspect}"
      return
    end

    race_session_adapter = RaceSessionAdapter.new(@race_session)
    satellite_check_point = race_session_adapter.track_satellite_check_point(params[:transponder_token])

    render json: satellite_check_point
  end
end
