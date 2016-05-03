class RoleAdRaceDirector < ActiveRecord::Migration
  def change
	Role.create(name: "race_director")
  end
end
