class MonitorChannel < ApplicationCable::Channel
  def subscribed
    stream_from "monitor"
  end
en
