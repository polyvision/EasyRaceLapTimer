class RaceBoxReceiverChannel < ApplicationCable::Channel
  def subscribed
    stream_from "race_box_receiver"
  end
end
