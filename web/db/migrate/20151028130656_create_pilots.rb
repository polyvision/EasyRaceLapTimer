class CreatePilots < ActiveRecord::Migration
  def change
    create_table :pilots do |t|

      t.string :name
      t.string :image
      t.string :transponder_token
    end
  end
end
