class RaceDirectorController < ApplicationController
  before_action :authenticate_user!

  def index
    @custom_soundfiles = CustomSoundfile.order("title ASC")

    @current_race_session = RaceSession::get_open_session
    @current_race_session_adapter = RaceSessionAdapter.new(@current_race_session) if @current_race_session
  end
end
