class Image < ActiveRecord::Base
  mount_uploader :asset, ImageUploader
  belongs_to :user
end
