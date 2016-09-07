class NewConfigValues < ActiveRecord::Migration
  def change
    ConfigValue::set_value("lap_min_lap_time_in_seconds","10")
    ConfigValue::set_value("time_between_lap_track_requests_in_seconds","4")
    t = ConfigValue.where(name: "lap_timeout_in_seconds").first
    t.delete if t
  end
end
