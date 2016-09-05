class PilotsFpvsportsRaceEventPilotId < ActiveRecord::Migration[5.0]
  def change
    add_column :pilots, :fpvsports_race_event_pilot_id, :integer, default:0, index: true
  end
end
