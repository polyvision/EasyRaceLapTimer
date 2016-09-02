class Api::V1::RaceBoxController < Api::V1Controller

    def update_receiver
        receiver = RaceBoxReceiver.where(name: params[:vtx]).first
        if receiver
            receiver.current_rssi = params[:crssi] if !params[:crssi].blank?
            receiver.saved_rssi = params[:srssi] if !params[:srssi].blank?
            receiver.save

            send_racebox_receiver_update(receiver)
        end

        render status: 200, plain: ""
    end

    private

    def send_racebox_receiver_update(receiver)
      ActionCable.server.broadcast 'race_box_receiver', receiver_data: receiver
    end
end
