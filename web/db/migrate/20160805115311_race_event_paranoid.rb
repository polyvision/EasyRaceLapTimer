class RaceEventParanoid < ActiveRecord::Migration[5.0]
  def change
    add_column :race_events, :deleted_at, :datetime
    add_index :race_events, :deleted_at
  end
end
