class Api::V1::RaceSessionController < Api::V1Controller
  def new
    RaceSession::stop_open_session()

    race_session = RaceSession.create(title: "Race #{Time.now.to_s(:long)}",active: true)
    render json: race_session.to_json
  end
end
