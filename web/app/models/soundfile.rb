class Soundfile < ActiveRecord::Base
  mount_uploader :file,SoundfileUploader
end
