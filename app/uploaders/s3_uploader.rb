require 'exiftool'

class S3Uploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :fog

  process :validate_dimensions

  version :normal do
    process convert: 'jpg'
    process resize_to_limit: [1000, 1000]
    process quality: 100
    process :parse_exif
  end
  version :small, from_version: :normal do
    process convert: 'jpg'
    process resize_to_fill: [380, 380]
    process quality: 70
  end
  version :xsmall, from_version: :small do
    process convert: 'jpg'
    process resize_to_fill: [180, 180]
    process quality: 70
  end

  def extension_white_list
    %w(jpg jpeg)
  end

  def filename
    "#{ENV["IMG_PROCESS_VER"]}_#{secure_token}.#{file.extension}" if original_filename.present?
  end

  def quality(percentage)
    manipulate! do |img|
      img.quality(percentage.to_s)
      img = yield(img) if block_given?
      img
    end
  end

  def _get_season( month, hemisphere )
    ## 계절 상수
    #
    # 북반구
    # 
    # 봄1   3,4,5
    # 여름2 6,7,8
    # 가을3 9,10,11
    # 겨울4 12,1,2
    #
    #
    # 남반구
    #
    # 봄1   9,10,11
    # 여름2 12,1,2
    # 가을3 3,4,5
    # 겨울4 6,7,8

    return nil unless (1..12).include? month
    season = case month
      when 3,4,5   then 1
      when 6,7,8   then 2
      when 9,10,11 then 3
      when 12,1,2  then 4
    end
    (hemisphere == 's') ? [1,2,3,4].rotate(-2)[season - 1]  : season
  end

  def parse_exif
    e = Exiftool.new(file.path)

    # 북반구인가 남반구인가?
    hemisphere = (e[:gps_latitude_ref] || "n").downcase.include?("n") ? "n" : "s"
    year = e[:create_date].nil? ? nil : e[:create_date].split(':')[0].to_i
    month = e[:create_date].nil? ? nil : e[:create_date].split(':')[1].to_i
    model.season = _get_season( month, hemisphere )

    model.year = year
    model.exif = e.to_json 
  end

  def validate_dimensions
    manipulate! do |img|
      if img.dimensions.any?{|i| i > 8000 }
        raise CarrierWave::ProcessingError, "dimensions too large"
      end
      img
    end
  end

  protected
  def secure_token
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.uuid)
  end

end
