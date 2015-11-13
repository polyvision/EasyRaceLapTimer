class PilotQuad < ActiveRecord::Migration
  def change
    add_column :pilots, :quad, :string
  end
end
