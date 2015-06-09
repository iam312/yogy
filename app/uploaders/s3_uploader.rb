class S3Uploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :fog
  version :normal do
    process resize_to_limit: [1000, 800]
  end
  version :small, from_version: :normal do
    process resize_to_fill: [380, 280]
  end

  def extension_white_list
    %w(jpg jpeg)
  end

  def filename
    "#{secure_token}.#{file.extension}" if original_filename.present?
  end

  protected
  def secure_token
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.uuid)
  end

end
