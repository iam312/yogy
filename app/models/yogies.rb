class Yogies < ActiveRecord::Base
  #has_one :image, dependent: :destroy
  belongs_to :image  
  has_many :users 

  def self.by_count
    result = []

    Rails.cache.fetch( 'index', :expires_in => 1.minutes ) do
      yogies = group( :title ).count.sort_by {|_key, value| value}.reverse.take(5)
      yogies.each do |yogy|
        title = yogy[0]
        count = yogy[1]

        # 최적 이미지 4개 추출, 지금은 최신 순
        best_image_ids = Yogies.where( { title: title } ).order( 'created_at desc' ).limit(4).map{ |yogy| yogy.image_id }

        result << { title: title,
          count: count,
          images: Image.where( { id: best_image_ids } ).available_images.order( 'view_count desc').order( 'created_at desc' )
        }
      end

      result
    end
  end

  def self.by_title( title, season = nil, year = nil )
    cache_key = "yogies_by_title_#{title}_#{season}_#{year}"
    Rails.cache.fetch( cache_key, :expires_in => 1.minutes ) do
      condition = { yogies: {title: title} }
      images_condition = { deleted: 0, dislike: 0..(ENV["BLIND_LIMIT"].to_i - 1) }
      images_condition[:season] = season unless season.blank?
      images_condition[:year] = year unless year.blank?
      condition[:images] = images_condition unless images_condition.blank?
      Yogies.includes( :image ).where( condition ).order( 'images.view_count desc').order( 'yogies.created_at desc' )
    end
  end

  def self.extra( yogies )
    seasons = []
    years = []

    yogies.each do |yogy|
      begin
        exif = JSON.parse(yogy.image.exif, :symbolize_names => true)
        years << exif[:create_date].split(":")[0].to_i
      rescue
      end
      seasons << yogy.image.season unless yogy.image.season.blank?
    end

    { seasons: seasons.uniq.sort,
      years: years.uniq.sort.reverse,
    }
  end

  def self.extra_by_images( images )
    seasons = []
    years = []

    images.each do |image|
      begin
        exif = JSON.parse(image.exif, :symbolize_names => true)
        years << exif[:create_date].split(":")[0].to_i
      rescue
      end
      seasons << image.season unless image.season.blank?
    end

    { seasons: seasons.uniq.sort,
      years: years.uniq.sort.reverse,
    }
  end

  def to_param
    title
  end
end

