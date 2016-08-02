class RaceEventGroupEntryPilotId < ActiveRecord::Migration[5.0]
  def change
    add_column :race_event_group_entries, :pilot_id, :integer, index: true
  end
end
