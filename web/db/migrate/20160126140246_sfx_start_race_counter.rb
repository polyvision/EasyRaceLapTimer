class SfxStartRaceCounter < ActiveRecord::Migration
  def change
    Soundfile.where(name: 'sfx_start_race_count_down').first_or_create
    Soundfile.where(name: 'sfx_race_finished').first_or_create
  end
end
