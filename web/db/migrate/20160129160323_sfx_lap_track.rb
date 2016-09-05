class SfxLapTrack < ActiveRecord::Migration
  def change
    Soundfile.where(name: 'sfx_lap_track_number_1').first_or_create
    Soundfile.where(name: 'sfx_lap_track_number_2').first_or_create
    Soundfile.where(name: 'sfx_lap_track_number_3').first_or_create
    Soundfile.where(name: 'sfx_lap_track_number_4').first_or_create
    Soundfile.where(name: 'sfx_lap_track_number_5').first_or_create
    Soundfile.where(name: 'sfx_lap_track_number_6').first_or_create
    Soundfile.where(name: 'sfx_lap_track_number_7').first_or_create
    Soundfile.where(name: 'sfx_lap_track_number_8').first_or_create
    Soundfile.where(name: 'sfx_lap_track_number_9').first_or_create
    Soundfile.where(name: 'sfx_lap_track_number_10').first_or_create
  end
end
