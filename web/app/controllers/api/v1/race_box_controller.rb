class Api::V1::RaceBoxController < Api::V1Controller

    def update_receiver
        receiver = RaceBoxReceiver.where(name: params[:vtx]).first
        if receiver
            receiver.current_rssi = params[:crssi] if !params[:crssi].blank?
            receiver.saved_rssi = params[:srssi] if !params[:srssi].blank?
            receiver.save 
        end

        render status: 200, plain: ""
    end

    private

end
