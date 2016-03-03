class SfxLapEvents < ActiveRecord::Migration
  def change
    Soundfile.where(name: 'sfx_lap_final_round').first_or_create
  end
end
