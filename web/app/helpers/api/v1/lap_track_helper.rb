module Api::V1::LapTrackHelper
def send_monitor_update message
  html = render_message(message)
  ActionCable.server.broadcast 'monitor', html: html
end

def render_message message
  @current_race_session = RaceSession::get_open_session
  @current_race_session_adapter = RaceSessionAdapter.new(@current_race_session)

  ApplicationController.render({
    file:'/monitor/_view.html.haml'
  })
end
end
