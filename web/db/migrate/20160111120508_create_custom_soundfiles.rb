class CreateCustomSoundfiles < ActiveRecord::Migration
  def change
    create_table :custom_soundfiles do |t|

      t.string :title
      t.string :file
    end
  end
end
