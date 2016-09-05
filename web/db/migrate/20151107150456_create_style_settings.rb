class CreateStyleSettings < ActiveRecord::Migration
  def change
    create_table :style_settings do |t|

      t.timestamps null: false
      t.string :own_logo_image
    end
  end
end
