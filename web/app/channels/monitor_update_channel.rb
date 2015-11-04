class MonitorUpdateChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'monitor_notifications'
  end
end
