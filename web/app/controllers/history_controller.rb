class HistoryController < ApplicationController
  before_action :filter_needs_admin_role, only: [:delete]

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

  def invalidate_lap
    t = RaceSession.find(params[:race_session_id])
    lap = t.pilot_race_laps.where(id: params[:id]).first
    lap.mark_invalidated
    redirect_to action: 'show', id: t.id
  end

  def validate_lap
    t = RaceSession.find(params[:race_session_id])
    lap = t.pilot_race_laps.where(id: params[:id]).first
    lap.undo_invalidated
    redirect_to action: 'show', id: t.id
  end

  def merge_up
    t = RaceSession.find(params[:race_session_id])
    lap = t.pilot_race_laps.where(id: params[:id]).first
    lap.merge_up
    redirect_to action: 'show', id: t.id
  end

  def merge_down
    t = RaceSession.find(params[:race_session_id])
    lap = t.pilot_race_laps.where(id: params[:id]).first
    lap.merge_down
    redirect_to action: 'show', id: t.id
  end

  def unmerge
    t = RaceSession.find(params[:race_session_id])
    lap = t.pilot_race_laps.where(id: params[:id]).first
    lap.unmerge
    redirect_to action: 'show', id: t.id
  end

  def delete
    t = RaceSession.find(params[:id])
    t.destroy
    redirect_to action: 'index'
  end

  def synchronize_fpv_sports

    if !current_user || !current_user.has_role?(:admin)
      redirect_to "/"
      return
    end

    race_session = RaceSession.find(params[:race_session_id])
    adapter = FpvSportsApiAdapter.new()
    result = adapter.report_race_result(ConfigValue::get_value("fpvsports_racing_event_id").value,FpvSportsRaceResultAdapter::build_hash(race_session))

    if result
      flash['notice'] = "Synchronized successfully with FPV-SPORTS.IO"
      redirect_to action: 'index'
    else
      flash['error'] = adapter.error

      redirect_to action: 'index'
    end
  end

  def pdf
    @style_setting = StyleSetting.where(id: 1).first_or_create
    @current_race_session = RaceSession.find(params[:id])
    @current_race_session_adapter = RaceSessionAdapter.new(@current_race_session)

    respond_to do |format|
      format.html
      format.pdf do
        @current_format = :pdf
        render pdf: "race_session_#{@current_race_session.id}.pdf",
        page_size: 'A4',
        show_as_html: params.key?('debug'),
        template: 'history/pdf_body.html.haml',
        layout: 'pdf.html',
        orientation: 'landscape',
        footer:  {
          html: {
            template:'history/pdf_footer.html.haml'
          }
        },
        header:  {
          html: {
            template:'history/pdf_header.html.haml'
          }
        }
      end
    end
  end

  def pdf_body
    @current_race_session = RaceSession.find(params[:id])
    @current_race_session_adapter = RaceSessionAdapter.new(@current_race_session)
  end
end
