require "#{Rails.root}/lib/ir_daemon_cmd.rb"

class System::RaceBoxController < SystemController

    def index
        @race_box_receivers = RaceBoxReceiver.all
    end

    def get_saved_rssi
        IRDaemonCmd::send("RB_SRSSI#\n")
        redirect_to action: 'index'
    end

    def get_current_rssi
        IRDaemonCmd::send("RB_CRSSI#\n")
        redirect_to action: 'index'
    end

    def set_saved_rssi
        IRDaemonCmd::send("RB_SC_RSSI #{params[:vtx_id]} #{params[:rssi]}#\n")
        redirect_to action: 'index'
    end
end
