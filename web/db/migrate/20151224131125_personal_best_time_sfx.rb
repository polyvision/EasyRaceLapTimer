class PersonalBestTimeSfx < ActiveRecord::Migration
  def change
    Soundfile.where(name: 'sfx_personal_fastet_lap').first_or_create
  end
end
