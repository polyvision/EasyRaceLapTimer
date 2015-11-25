class PilotRaceLapParanoid < ActiveRecord::Migration
  def change
  	add_column :pilot_race_laps, :deleted_at, :datetime
    add_index :pilot_race_laps, :deleted_at
  end
end
