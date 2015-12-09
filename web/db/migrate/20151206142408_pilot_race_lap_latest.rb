class PilotRaceLapLatest < ActiveRecord::Migration
  def change
    add_column :pilot_race_laps, :latest, :boolean, index: true
  end
end
