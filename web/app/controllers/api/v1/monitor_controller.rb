class Api::V1::MonitorController < Api::V1Controller
  def index
    @race_session =  RaceSession::get_open_session
    if !@race_session
      render status: 409, text: 'no open race session'
      return
    end

    race_session_adapater = RaceSessionAdapter.new(@race_session)
    json_data = Hash.new
    json_data['session'] = Hash.new#
    json_data['session']['title'] = @race_session.title
    json_data['session']['maps_laps'] = @race_session.max_laps
    json_data['session']['current_lap_count'] = race_session_adapater.current_lap_count
    json_data['data'] = race_session_adapater.listing
    render json: json_data
  end
end
