class AddAdminToDefaultUser < ActiveRecord::Migration
  def change
	User.first.add_role(:admin) if User.first
  end
end
