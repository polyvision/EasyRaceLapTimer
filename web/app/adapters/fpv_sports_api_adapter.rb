=begin
  FpvSportsApiAdapter::list_racing_events
  FpvSportsApiAdapter::list_pilots_of_racing_event(1)
  FpvSportsApiAdapter::get_current_group(1)

  FpvSportsApiAdapter::report_race_result(1,FpvSportsRaceResultAdapter::build_hash(RaceSession.find(2)))
=end

class FpvSportsApiAdapter
  attr_accessor :error

  def initialize()
    self.error = nil
  end

  def list_racing_events
    begin
      res = RestClient.get "#{ConfigValue::get_value("fpvsports_api_host").value}/api/v1/racing_events" ,{"Authorization" => "Token #{ConfigValue::get_value("fpvsports_api_token").value}"}
      return JSON::parse(res.body)
    rescue Exception => ex
      self.error = ex.message
    end

    return Hash.new
  end

  def list_pilots_of_racing_event(racing_event_id)
    begin
      res = RestClient.get "#{ConfigValue::get_value("fpvsports_api_host").value}/api/v1/racing_events/#{racing_event_id}/pilots" ,{"Authorization" => "Token #{ConfigValue::get_value("fpvsports_api_token").value}"}
      return JSON::parse(res.body)
    rescue Exception => ex
      self.error = ex.message
    end

    return false
  end

  def self.get_current_group(racing_event_id)
    res = RestClient.get "#{ConfigValue::get_value("fpvsports_api_host").value}/api/v1/racing_events/#{racing_event_id}/groups" ,{"Authorization" => "Token #{ConfigValue::get_value("fpvsports_api_token").value}"}
    return JSON::parse(res.body)
  end

  def report_race_result(racing_event_id,result_hash)
    begin
      res = RestClient.post "#{ConfigValue::get_value("fpvsports_api_host").value}/api/v1/racing_events/#{racing_event_id}/result" ,result_hash.to_json,{"Authorization" => "Token #{ConfigValue::get_value("fpvsports_api_token").value}",content_type: 'application/json', accept: 'application/json'}
    rescue Exception => ex
      self.error = "#{ex.message}: #{ex.response}"
      return false
    end
      return true
  end
end
