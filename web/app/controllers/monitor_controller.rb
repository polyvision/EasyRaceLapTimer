class MonitorController < ApplicationController
  before_action :filter_style_setting

  def index
    @current_race_session = RaceSession::get_open_session
    @current_race_session_adapter = RaceSessionAdapter.new(@current_race_session)
  end

  def view
    @current_race_session = RaceSession::get_open_session
    @current_race_session_adapter = RaceSessionAdapter.new(@current_race_session)

    if !@current_race_session
      render text: ""
    else
      render layout: false
    end
  end

  private

  def filter_style_setting
    @style_setting = StyleSetting.where(id: 1).first_or_create
  end
end
