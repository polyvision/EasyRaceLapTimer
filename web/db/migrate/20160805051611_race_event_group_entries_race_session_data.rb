class RaceEventGroupEntriesRaceSessionData < ActiveRecord::Migration[5.0]
  def change
    remove_column :race_event_group_entries, :round_no

    add_column :race_event_group_entries, :fastest_lap_time, :integer, default: 0
    add_column :race_event_group_entries, :total_time, :integer, default: 0
    add_column :race_event_group_entries, :placement, :integer, default: 0
  end
end
