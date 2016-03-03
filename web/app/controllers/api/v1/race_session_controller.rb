class Api::V1::RaceSessionController < Api::V1Controller
  def new
    RaceSession::stop_open_session()

    race_session = RaceSession.create(title: "Race #{Time.now.to_s(:long)}",active: true)
    SoundFileWorker.perform_async("sfx_start_race")
    render json: race_session.to_json
  end

  def new_competition
    RaceSession::stop_open_session()

    json_input_data = JSON::parse(params[:data])

    race_session = RaceSession.create(hot_seat_enabled: json_input_data['hot_seat_enabled'],title: json_input_data['title'],active: true, mode: "competition", max_laps: json_input_data['max_laps'],num_satellites: json_input_data['num_satellites'],time_penalty_per_satellite: json_input_data['time_penalty_per_satellite'], idle_time_in_seconds: json_input_data['idle_time_in_seconds'] )

    race_session_adapter = RaceSessionAdapter.new(race_session)
    race_session_adapter.add_pilots_to_competition_race(json_input_data['pilots'])
    race_session.update_attribute(:active,true)
    render status: 200, text: ""
  end

  def update_race_session_idle_time
    @race_session = RaceSession::get_open_session()
    if @race_session && @race_session.idle_time_in_seconds > 0
        if  @race_session.last_created_at_of_tracked_lap + @race_session.idle_time_in_seconds.seconds <= Time.now
          # looks like he have to stop this race
          RaceSession::stop_open_session
          SoundFileWorker.perform_async("sfx_race_finished")
        end
    end

    render status: 200, text: ''
  end
end
