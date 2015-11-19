class CreateSoundfiles < ActiveRecord::Migration
  def change
    create_table :soundfiles do |t|

      t.string :name
      t.string :file
    end
  end
end
