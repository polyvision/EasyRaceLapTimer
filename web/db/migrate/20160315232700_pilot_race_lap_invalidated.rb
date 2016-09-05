class PilotRaceLapInvalidated < ActiveRecord::Migration
  def change
    add_column :pilot_race_laps, :invalidated, :boolean, default:false, index: true
  end
end
