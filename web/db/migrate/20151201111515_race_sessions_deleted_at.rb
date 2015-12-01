class RaceSessionsDeletedAt < ActiveRecord::Migration
  def change
    add_column :race_sessions, :deleted_at, :datetime
    add_index :race_sessions, :deleted_at
  end
end
