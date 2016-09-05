class StyleSetting < ActiveRecord::Base
  mount_uploader :own_logo_image,OwnLogoImageUploader
end
