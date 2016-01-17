=begin
load "#{Rails.root}/lib/ir_daemon_cmd.rb"
IRDaemonCmd::get_info_server_value("LAST_SCANNED_TOKEN")

IRDaemonCmd::send("SHUTDOWN#\n")
=end
require 'socket'

class IRDaemonCmd
  def self.send(cmd)
    begin
      s = TCPSocket.new 'localhost', 3006
      s.send cmd,0
      s.close
    rescue Exception => ex
    	puts ex.message
    end
  end

  def self.get_info_server_value(val)
  	begin
      s = TCPSocket.new 'localhost', 3007
      s.send "#{val}#\n",0
      while line = s.gets # Read lines from socket
  		puts line         # and print them
  		s.close
  		return line.gsub("#","").gsub("\n","")
	 end
    rescue Exception => ex
    	puts ex.message
    end
  end
end
