class UdpBroadcastAddressConfigValue < ActiveRecord::Migration
  def change
    ConfigValue::set_value("udp_broadcast_address","192.168.42.1")
  end
end
