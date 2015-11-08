class MonitorController < ApplicationController
  before_action :filter_style_setting
  
  def index
    @current_race_session = RaceSession::get_open_session
  end

  def view
    @current_race_session = RaceSession::get_open_session
    render layout: false
  end

  private

  def filter_style_setting
    @style_setting = StyleSetting.where(id: 1).first_or_create
  end
end
