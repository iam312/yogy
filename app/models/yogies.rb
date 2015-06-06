class Yogies < ActiveRecord::Base
  has_many :images, dependent: :destroy
  has_many :users 
end

