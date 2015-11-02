class CreateRaceSessions < ActiveRecord::Migration
  def change
    create_table :race_sessions do |t|

      t.timestamps null: false
      t.string  :title
      t.boolean :active
    end
  end
end
