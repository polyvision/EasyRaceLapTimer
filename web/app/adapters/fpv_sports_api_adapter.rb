=begin
  FpvSportsApiAdapter::list_racing_events
  FpvSportsApiAdapter::list_pilots_of_racing_event(1)
=end

class FpvSportsApiAdapter

  def initialize()

  end

  def self.list_racing_events
    #
    res = RestClient.get "#{ConfigValue::get_value("fpvsports_api_host").value}/api/v1/racing_events" ,{"Authorization" => "Token #{ConfigValue::get_value("fpvsports_api_token").value}"}
    return JSON::parse(res.body)
  end

  def self.list_pilots_of_racing_event(racing_event_id)
    res = RestClient.get "#{ConfigValue::get_value("fpvsports_api_host").value}/api/v1/racing_events/#{racing_event_id}/pilots" ,{"Authorization" => "Token #{ConfigValue::get_value("fpvsports_api_token").value}"}
    return JSON::parse(res.body)
  end
end
