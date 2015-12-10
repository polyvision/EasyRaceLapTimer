class RaceSessionMaxLaps < ActiveRecord::Migration
  def change
	add_column :race_sessions, :max_laps, :integer, default: 0
  end
end
