module Yogy
  module Dn
    def get_dn_url( image_id, type )
      image = Image.find image_id
      image.s3.send(type).url
    end
  end
end

