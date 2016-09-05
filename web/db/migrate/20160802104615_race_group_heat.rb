class RaceGroupHeat < ActiveRecord::Migration[5.0]
  def change
    add_column :race_event_groups, :heat_no, :integer, default: 0, index: true
  end
end
