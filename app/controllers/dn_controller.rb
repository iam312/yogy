class DnController < ApplicationController
  include Yogy::Dn

  def show
    image_id = params[:image_id]
    type = params[:type]

    begin
      image_array = Rails.cache.fetch( "#{image_id}_#{type}", :expires_in => 48.hours ) do
        image_url = get_dn_url( image_id, type )
        uri = URI(image_url)
        Net::HTTP.get(uri) # => String
      end
      response.headers['Content-Type'] = 'image/jpeg' 
      #response.headers['X-Accel-Buffering'] = 'no'
      #response.headers['Cache-Control'] ||= 'no-cache'
      response.headers['Content-Length'] = image_array.size
      response.stream.write image_array
      response.stream.close

      return
    rescue => e
      Rails.logger.error e
      @msg = '다운로드 중 에러가 발생했습니다.'
      render :text => @msg
    end
  end

end
