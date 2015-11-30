class RaceSessionMode < ActiveRecord::Migration
  def change
	add_column :race_sessions, :mode, :integer, default: 0
  end
end
