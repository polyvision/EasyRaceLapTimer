class PilotTeam < ActiveRecord::Migration
  def change
    add_column :pilots, :team, :string
  end
end
