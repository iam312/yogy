class Disliker < ActiveRecord::Base
  belongs_to :image
  belongs_to :user

  def self.am_i?( user_id, image_id )
    where( { user_id: user_id, image_id: image_id } ).count > 0 ? true : false
  end
end


