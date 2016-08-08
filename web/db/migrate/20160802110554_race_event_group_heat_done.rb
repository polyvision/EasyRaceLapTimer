class RaceEventGroupHeatDone < ActiveRecord::Migration[5.0]
  def change
    add_column :race_event_groups, :heat_done, :bool, default: false
  end
end
