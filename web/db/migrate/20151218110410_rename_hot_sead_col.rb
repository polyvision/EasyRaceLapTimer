class RenameHotSeadCol < ActiveRecord::Migration
  def change
	rename_column :race_sessions, :hot_sead_enabled,:hot_seat_enabled
  end
end
