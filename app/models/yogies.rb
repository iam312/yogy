class Yogies < ActiveRecord::Base
  mount_uploader :image, ImageUploader
end
