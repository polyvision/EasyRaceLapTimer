class RaceEventActive < ActiveRecord::Migration[5.0]
  def change
    add_column :race_events, :active, :bool , default: true
  end
end
