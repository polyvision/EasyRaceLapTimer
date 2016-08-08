class CreateRaceEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :race_events do |t|

      t.timestamps
      t.string :title
      t.integer :number_of_pilots_per_group, default: 4
    end
  end
end
