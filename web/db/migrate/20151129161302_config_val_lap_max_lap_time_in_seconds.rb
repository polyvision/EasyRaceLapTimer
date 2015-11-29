class ConfigValLapMaxLapTimeInSeconds < ActiveRecord::Migration
  def change
	ConfigValue::set_value("lap_max_lap_time_in_seconds","60")
  end
end
