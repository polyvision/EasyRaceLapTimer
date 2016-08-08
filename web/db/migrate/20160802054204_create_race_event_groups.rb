class CreateRaceEventGroups < ActiveRecord::Migration[5.0]
  def change
    create_table :race_event_groups do |t|

      t.timestamps
      t.integer :race_event_id, index: true
      t.integer :group_no
      t.integer :placement, index: true
      t.integer :points, index: true
    end
  end
end
