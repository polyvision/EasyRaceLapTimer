class Pilot < ActiveRecord::Base
  acts_as_paranoid
  mount_uploader :image, PilotImageUploader
end
