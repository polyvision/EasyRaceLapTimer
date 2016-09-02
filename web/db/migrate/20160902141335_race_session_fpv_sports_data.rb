class RaceSessionFpvSportsData < ActiveRecord::Migration[5.0]
  def change
    add_column :race_sessions, :fpv_sports_racing_event_id, :integer, default: 0
    add_column :race_sessions, :fpv_sports_race_event_heat_id, :integer, default: 0
    add_column :race_sessions, :fpv_sports_race_event_heat_group_id, :integer, default: 0
    add_column :race_sessions, :fpv_sports_race_event_heat_num, :integer, default: 0
    add_column :race_sessions, :fpv_sports_race_event_heat_group_num, :integer, default: 0
  end
end
