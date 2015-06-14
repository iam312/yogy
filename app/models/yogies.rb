class Yogies < ActiveRecord::Base
  has_many :images, dependent: :destroy
  has_many :users 

  def self.by_count
    result = []

    Rails.cache.fetch( 'index', :expires_in => 10.minutes ) do
      yogies = group( :title ).count.sort_by {|_key, value| value}.reverse 
      yogies.each do |yogy|
        title = yogy[0]
        count = yogy[1]

        # 최적 이미지 4개 추출, 지금은 최신 순
        best_image_ids = Yogies.where( { title: title } ).order( 'created_at desc' ).limit(4).map{ |yogy| yogy.image_id }

        result << { title: title,
          count: count,
          images: Image.where( { id: best_image_ids } ).order( 'created_at desc' )
        }
      end

      result
    end

    #result
  end
end

