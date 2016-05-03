class AddAdminToDefaultUser < ActiveRecord::Migration
  def change
	User.first.add_role(:admin)
  end
end
