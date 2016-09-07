class RaceEventRaceSessionId < ActiveRecord::Migration[5.0]
  def change
    add_column :race_event_groups, :race_session_id, :integer, index: true
  end
end
