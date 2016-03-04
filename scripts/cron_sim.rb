require 'rubygems'
require 'rest-client'

puts "platform: #{RUBY_PLATFORM}"


while(true) do
  RestClient.get "http://localhost:3000/api/v1/race_session/update_race_session_idle_time"
  sleep(60)
end
