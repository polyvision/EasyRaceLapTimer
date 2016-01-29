class RaceSessionEventAdapter
  attr_accessor :transponder_token, :race_session_adapter

  def initialize(race_session_adapter,transponder_token)
    self.race_session_adapter = race_session_adapter
    self.transponder_token = transponder_token
  end
end
