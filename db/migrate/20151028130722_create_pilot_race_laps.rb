class CreatePilotRaceLaps < ActiveRecord::Migration
  def change
    create_table :pilot_race_laps do |t|

      t.timestamps null: false
      t.integer :pilot_id, index: true
      t.integer :lap_num, index: true
      t.integer :lap_time, index: true
    end
  end
end
