class UsersPinCode < ActiveRecord::Migration
  def change
	add_column :users, :pin_code, :integer, default: 1234, index: true
  end
end
