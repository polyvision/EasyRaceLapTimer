class SatelliteCheckPointsLapNum < ActiveRecord::Migration
  def change
	add_column :satellite_check_points, :num_lap, :integer, default:0, index: true
	add_index :satellite_check_points, :race_session_id
	add_index :satellite_check_points, :race_attendee_id
  end
end
