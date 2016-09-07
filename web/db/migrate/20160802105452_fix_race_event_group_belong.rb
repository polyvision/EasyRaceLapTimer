class FixRaceEventGroupBelong < ActiveRecord::Migration[5.0]
  def change
    remove_column :race_event_group_entries,:race_event_group
    add_column :race_event_group_entries,:race_event_group_id, :integer, index: true
  end
end
