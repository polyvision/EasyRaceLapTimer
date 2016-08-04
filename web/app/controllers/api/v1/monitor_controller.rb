class Api::V1::MonitorController < Api::V1Controller
  def index
    @race_session =  RaceSession::get_open_session
    if !@race_session
      render status: 409, plain: 'no open race session'
      return
    end

    render json: RaceSessionAdapter.new(@race_session).monitor_data.to_json
  end
end
