class AddDeletedAtToPilots < ActiveRecord::Migration
  def change
    add_column :pilots, :deleted_at, :datetime
    add_index :pilots, :deleted_at
  end
end
