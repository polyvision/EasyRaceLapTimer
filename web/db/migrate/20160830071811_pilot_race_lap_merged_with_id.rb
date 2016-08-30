class PilotRaceLapMergedWithId < ActiveRecord::Migration[5.0]
  def change
    add_column :pilot_race_laps, :merged_with_id, :integer, index: true, default: 0
  end
end
