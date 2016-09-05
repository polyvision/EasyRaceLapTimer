class CreateSatelliteCheckPoints < ActiveRecord::Migration
  def change
    create_table :satellite_check_points do |t|

      t.timestamps null: false
      t.integer :race_session_id
      t.integer :race_attendee_id
    end
  end
end
