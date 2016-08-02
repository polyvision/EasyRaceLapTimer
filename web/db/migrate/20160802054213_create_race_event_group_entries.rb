class CreateRaceEventGroupEntries < ActiveRecord::Migration[5.0]
  def change
    create_table :race_event_group_entries do |t|

      t.timestamps
      t.integer :race_event_group
      t.string :token
      t.integer :round_no
    end
  end
end
