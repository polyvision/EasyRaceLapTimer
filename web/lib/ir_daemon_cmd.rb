require 'socket'

class IRDaemonCmd
  def self.send(cmd)
    s = TCPSocket.new 'localhost', 3006
    s.send CMD
    s.close
  end
end
