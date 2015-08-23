class Image < ActiveRecord::Base
  validates :s3, presence: true
  validates :user_id, presence: true
  validates :yogies, presence: true

  mount_uploader :s3, S3Uploader

  belongs_to :user

  scope :available_images, -> { where({ deleted: 0 }).where("dislike < #{ENV["BLIND_LIMIT"]}") }
  scope :filter_by_user, ->(user_id, offset, limit) { where( user_id: user_id ).available_images.order('created_at desc').offset(offset).limit(limit) }
  scope :get_prev_image_id, ->(id) { where( ["id < ?", id] ).order( 'id desc' ).limit(1) }
  scope :get_next_image_id, ->(id) { where( ["id > ?", id] ).order( 'id asc' ).limit(1) }
  scope :all_images, ->(offset, limit) { available_images.order('created_at desc').offset(offset).limit(limit) }

  def yogies_to_array
    ::Yogy::Utils.yogies_to_array(yogies)
  end

  def yogies_with_picture_count
    yogies = yogies_to_array
    result = {}
    yogies.each do | yogy |
      yogy_records = Yogies.where( title: yogy )
      years = []
      seasons = []
      images = Image.where( id: yogy_records.map{ |y| y.image_id } ).where( "dislike < #{ENV["BLIND_LIMIT"]}" )
      images.each do |image|
        begin
          exif = JSON.parse( image.exif, :symbolize_names => true )
          years << exif[:create_date].split(":")[0].to_i
          seasons << image.season unless image.season.blank?
        rescue
        end
      end
      result[yogy] = { seasons: seasons.uniq.sort,
                       years: years.uniq.sort.reverse,
                       count: yogy_records.count }
    end

    result
  end

  def self.generate_yogies_with_images( images )
    yogies = {}
    images.each do |image|
      image.yogies_to_array.each do |yogy|
        yogies.has_key?(yogy) ? yogies[yogy] += 1 : yogies[yogy] = 1
      end
    end
    yogies.sort_by{ |k, v| v }.reverse.map{ |v| v[0] }
  end

  def process!( current_user )
    yogy_ids = []
    image = Image.find_by id: id
    image.transaction do 
      #hash_tags = yogies.split('#').drop(1).map { |item| item[/[[:word:] ]+/].strip.gsub(/\s+/, '_') }
      hash_tags = yogies_to_array
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

  def update_yogies!( current_user, yogies )
    will_be_added_yogy_ids = []
    will_be_deleted_yogy_ids = []
    transaction do 
      ## 현재 Yogies::hash_to_id 매핑 정보
      tag_to_yogyid_map = {}
      Yogies.where( { image_id: id } ).each{ |yogy| tag_to_yogyid_map[yogy.title] = yogy.id }


      new_hash_tags = ::Yogy::Utils.yogies_to_array( yogies )
      old_hash_tags = yogies_to_array

      will_be_deleted_hash_tags = old_hash_tags - new_hash_tags
      will_be_deleted_yogy_ids = tag_to_yogyid_map.select{ |r| r if will_be_deleted_hash_tags.include? r }.values

      will_be_added_hash_tags = new_hash_tags - old_hash_tags

      ## 추가될 tag 처리
      will_be_added_hash_tags.each do |hash_tag|
        yogy = Yogies.new
        yogy.title = hash_tag
        yogy.image_id = id
        yogy.user_id = current_user.id
        yogy.save!
        will_be_added_yogy_ids << yogy.id
      end

      ## 삭제될 tag 처리
      Yogies.delete( will_be_deleted_yogy_ids )

      ## Images.yogy_ids 처리
      yogy_ids = (tag_to_yogyid_map.values - will_be_deleted_yogy_ids + will_be_added_yogy_ids).map(&:inspect).join(',')
      self.yogy_ids = yogy_ids
      self.yogies = yogies
      save!
    end
  end

  def self.deleted?( id )
    image = find_by_id id
    image.deleted?
  end

  def deleted?
    deleted == 1 ? true : false
  end

  def self.blinded?( id )
    image = find_by_id id
    image.blinded?
  end

  def blinded?
    dislike.to_i > 5 ? true : false
  end

  def self.user_disabled?( id )
    image = find_by_id id
    image.user_disabled?
  end

  def user_disabled?
    user.enabled == false ? true : false
  end
end
