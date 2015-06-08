class ImagesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :destroy]

  def index
    @images = Image.all.reverse
  end

  def new
    @image = params[:image].blank? ? Image.new : Image.new(image_params)
  end

  def create
    @image = Image.new(image_params)
    @image.user_id = current_user.id

    begin
      raise ::Yogy::Exceptions::ImageInvalid.new "image is not setted." if image_params[:s3].blank?
      @image.transaction do
        @image.save

        #@image.delay.process!( current_user )
        @image.process!( current_user )
      end
    rescue => e
      Rails.logger.error e
      flash[:error] = I18n.t( 'error.fail_to_regist_image' )
      render "new"
      return
    end
    redirect_to image_path({id: @image.id }), notice: "The image #{@image.title} has been uploaded."
  end

  def destroy
  end

  def show
    @image = Image.find_by_id( params[:id] )
  end


  private

  def image_params
    params.require(:image).permit!
  end
end
