class PilotRaceLapRaceSession < ActiveRecord::Migration
  def change
    add_column :pilot_race_laps, :race_session_id, :integer, index: true
  end
end
