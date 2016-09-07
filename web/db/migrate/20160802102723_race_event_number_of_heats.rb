class RaceEventNumberOfHeats < ActiveRecord::Migration[5.0]
  def change
    add_column :race_events, :number_of_heats, :integer, default: 4
  end
end
