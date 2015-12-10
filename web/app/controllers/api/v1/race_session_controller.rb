class Api::V1::RaceSessionController < Api::V1Controller
  def new
    RaceSession::stop_open_session()

    race_session = RaceSession.create(title: "Race #{Time.now.to_s(:long)}",active: true)
    Soundfile::play("sfx_start_race")
    render json: race_session.to_json
  end

  def new_competition
    RaceSession::stop_open_session()

    json_input_data = JSON::parse(params[:data])
    race_session = RaceSession.create(title: json_input_data['title'],active: true, mode: "competition", max_laps: json_input_data['max_laps'],num_satellites: json_input_data['num_satellites'],time_penalty_per_satellite: json_input_data['time_penalty_per_satellite'] )

    race_session_adapter = RaceSessionAdapter.new(race_session)
    race_session_adapter.add_pilots_to_competition_race(json_input_data['pilots'])
    race_session.update_attribute(:active,true)
    render status: 200, text: ""
  end
end
