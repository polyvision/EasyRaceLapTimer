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

  def export_to_xlsx
    t = RaceSession.find(params[:id])
    data = RaceSessionExport.new(t).export_to_xlsx

    send_data data.to_stream.read, filename: "race_session_#{t.id}.xlsx", type:"application/xlsx"
  end

  def delete
    t = RaceSession.find(params[:id])
    t.destroy
    redirect_to action: 'index'
  end

  def pdf
    @current_race_session = RaceSession.find(params[:id])
    @current_race_session_adapter = RaceSessionAdapter.new(@current_race_session)

    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "race_session_#{@current_race_session.id}.pdf",
        page_size: 'A4',
        show_as_html: params.key?('debug'),
        template: 'history/pdf_body.html.haml',
        layout: 'pdf.html'
      end
    end
  end

  def pdf_body
    @current_race_session = RaceSession.find(params[:id])
    @current_race_session_adapter = RaceSessionAdapter.new(@current_race_session)
  end
end
