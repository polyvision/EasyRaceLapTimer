class Api::V1::PilotController < Api::V1Controller
  def index
    json_data = Array.new
    Pilot.all.each do |p|
      json_data << p
    end

    render json: json_data.to_json
  end
end
