class SfxRacePlacements < ActiveRecord::Migration
  def change
    Soundfile.where(name: 'sfx_race_pilot_placement_1').first_or_create
    Soundfile.where(name: 'sfx_race_pilot_placement_2').first_or_create
    Soundfile.where(name: 'sfx_race_pilot_placement_3').first_or_create
    Soundfile.where(name: 'sfx_race_pilot_placement_4').first_or_create
    Soundfile.where(name: 'sfx_race_pilot_placement_5').first_or_create
    Soundfile.where(name: 'sfx_race_pilot_placement_6').first_or_create
    Soundfile.where(name: 'sfx_race_pilot_placement_7').first_or_create
    Soundfile.where(name: 'sfx_race_pilot_placement_8').first_or_create
  end
end
