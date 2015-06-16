module Yogy
  module Dn
    def get_dn_url( image_id, type=nil )
      image = Image.find image_id
      type == "orig" ? image.s3.url : image.s3.send(type).url
    end

  end
end

