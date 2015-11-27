require 'socket'

class IRDaemonCmd
  def self.send(cmd)
    begin
      s = TCPSocket.new 'localhost', 3006
      s.send CMD
      s.close
    rescue Exception => ex
    end
  end
end
