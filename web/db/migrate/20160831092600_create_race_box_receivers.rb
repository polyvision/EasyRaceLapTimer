class CreateRaceBoxReceivers < ActiveRecord::Migration[5.0]
  def change
    create_table :race_box_receivers do |t|

      t.timestamps
      t.string :name
      t.integer :current_rssi
      t.integer :saved_rssi
    end

    RaceBoxReceiver.create(name: "VTX_1")
    RaceBoxReceiver.create(name: "VTX_2")
    RaceBoxReceiver.create(name: "VTX_3")
    RaceBoxReceiver.create(name: "VTX_4")
    RaceBoxReceiver.create(name: "VTX_5")
    RaceBoxReceiver.create(name: "VTX_6")
    RaceBoxReceiver.create(name: "VTX_7")
    RaceBoxReceiver.create(name: "VTX_8")
  end
end
