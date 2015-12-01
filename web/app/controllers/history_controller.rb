class HistoryController < ApplicationController
  before_action :authenticate_user!, only: [:delete]
  
  def index
    @race_sessions = RaceSession.where(active: false).order("id DESC")
  end

  def show
    @style_setting = StyleSetting.where(id: 1).first_or_create
    @current_race_session = RaceSession.find(params[:id])
    @current_race_session_adapter = RaceSessionAdapter.new(@current_race_session)
  end

  def delete
    t = RaceSession.find(params[:id])
    t.destroy
    redirect_to action: 'index'
  end
end
