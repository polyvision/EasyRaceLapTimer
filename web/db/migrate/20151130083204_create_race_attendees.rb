class CreateRaceAttendees < ActiveRecord::Migration
  def change
    create_table :race_attendees do |t|

      t.integer :race_session_id
      t.integer :pilot_id
      t.string  :transponder_token
    end
  end
end
