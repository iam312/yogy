class Image < ActiveRecord::Base
  validates :s3, presence: true
  validates :user_id, presence: true
  validates :yogies, presence: true

  mount_uploader :s3, S3Uploader

  belongs_to :user

  scope :get_next_image_id, ->(id) { where( ["id > ?", id] ).order( 'id asc' ).limit(1).first.andand.id }
  scope :get_prev_image_id, ->(id) { where( ["id < ?", id] ).order( 'id desc' ).limit(1).first.andand.id }


  def process!( current_user )
    yogy_ids = []
    image = Image.find_by id: id
    image.transaction do 
      hash_tags = yogies.split('#').drop(1).map { |item| item[/[[:word:] ]+/].strip.gsub(/\s+/, '_') }
      hash_tags.each do |hash_tag|
        yogy = Yogies.new
        yogy.title = hash_tag
        yogy.image_id = id
        yogy.user_id = current_user.id
        yogy.save!
        yogy_ids << yogy.id
      end

      image.yogy_ids = yogy_ids.map(&:inspect).join(',')
      image.save!
    end
  end
end
