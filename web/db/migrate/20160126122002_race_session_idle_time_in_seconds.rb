class RaceSessionIdleTimeInSeconds < ActiveRecord::Migration
  def change
    add_column :race_sessions, :idle_time_in_seconds, :integer ,default: 0
  end
end
