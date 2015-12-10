class RaceSessionHotseat < ActiveRecord::Migration
  def change
    add_column :race_sessions, :hot_sead_enabled, :boolean, default: false
  end
end
