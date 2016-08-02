class RailsEventNextHeadGroupingMode < ActiveRecord::Migration[5.0]
  def change
    add_column :race_events, :next_heat_grouping_mode, :integer, default: 0
  end
end
