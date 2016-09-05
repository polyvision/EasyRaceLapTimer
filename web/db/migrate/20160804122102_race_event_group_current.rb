class RaceEventGroupCurrent < ActiveRecord::Migration[5.0]
  def change
    add_column :race_event_groups, :current, :bool, default: false, index: true
  end
end
