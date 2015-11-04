class MonitorController < ApplicationController
  def index
    @current_race_session = RaceSession::get_open_session
  end

  def view
    @current_race_session = RaceSession::get_open_session
    render layout: false
  end
end
