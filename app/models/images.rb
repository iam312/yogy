class Images < ActiveRecord::Base
  mount_uploader :asset, ImageUploader
end
