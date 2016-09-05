class RaceSessionSatelliteOptions < ActiveRecord::Migration
  def change
    add_column :race_sessions, :num_satellites, :integer, default: 0
    add_column :race_sessions, :time_penalty_per_satellite, :integer, default: 2500
  end
end
