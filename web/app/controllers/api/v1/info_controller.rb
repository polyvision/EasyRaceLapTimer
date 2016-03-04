class Api::V1::InfoController < Api::V1Controller
	def last_scanned_token
		load "#{Rails.root}/lib/ir_daemon_cmd.rb"
		render text: IRDaemonCmd::get_info_server_value("LAST_SCANNED_TOKEN")
	end
end
