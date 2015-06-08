class S3Uploader < CarrierWave::Uploader::Base
  storage :fog
  def extension_white_list
    %w(jpg jpeg)
  end
end
