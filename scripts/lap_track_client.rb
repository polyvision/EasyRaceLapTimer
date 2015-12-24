=begin
TOKEN=1 MS=11200  HOST=localhost:3000 ruby lap_track_client.rb
=end

require 'rubygems'
require 'rest-client'


RestClient.post "http://#{ENV['HOST']}/api/v1/lap_track", :transponder_token => ENV['TOKEN'], :lap_time_in_ms => ENV['MS']
