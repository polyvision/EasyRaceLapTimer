class RaceEventCurrentHeat < ActiveRecord::Migration[5.0]
  def change
    add_column :race_events, :current_heat, :integer, default: 1
  end
end
