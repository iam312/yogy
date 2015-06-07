class Yogies < ActiveRecord::Base
  has_many :images, dependent: :destroy
  has_many :users 

  def self.by_count
    result = []
    yogies = group( :title ).count.sort_by {|_key, value| value}.reverse 
    yogies.each do |yogy|
      title = yogy[0]
      count = yogy[1]

      # 최적 이미지 3개 추출, 지금은 최신 순
      best_yogies = Yogies.where( { title: title } ).order( 'created_at desc' ).limit(3)
      best_image_ids = Yogies.where( { title: title } ).order( 'created_at desc' ).limit(3).map{ |yogy| yogy.image_id }

      result << { title: title,
        count: count,
        images: Image.find(best_image_ids)
      }
    end

    result
  end
end

