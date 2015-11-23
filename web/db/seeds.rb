# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

t = User.new
t.email = "admin@easyracelaptimer.com"
t.password = "defaultpw"
t.password_confirmation = "defaultpw"
t.save

ConfigValue::set_value("lap_timeout_in_seconds","4")
ConfigValue::set_value("lap_max_lap_time_in_seconds","60")

Soundfile.create(name: 'sfx_lap_beep')
Soundfile.create(name: 'sfx_start_race')
Soundfile.create(name: 'sfx_fastet_lap')
