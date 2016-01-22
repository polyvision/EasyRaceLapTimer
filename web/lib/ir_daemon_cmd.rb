=begin
load "#{Rails.root}/lib/ir_daemon_cmd.rb"
IRDaemonCmd::send("SHUTDOWN#\n")
=end
require 'socket'

class IRDaemonCmd
  def self.send(cmd)
    if Rails.env == "test"
      return
    end
    begin
      s = TCPSocket.new 'localhost', 3006
      s.send cmd,0
      s.close
    rescue Exception => ex
    	puts ex.message
    end
  end
end
