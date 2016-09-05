class RaceSessionFpvsportsSynchronized < ActiveRecord::Migration[5.0]
  def change
    add_column :race_sessions, :fpvsports_synchronized, :boolean, default: false
  end
end
