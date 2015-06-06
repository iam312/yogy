class ImagesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :destroy]

  def index
    @images = Image.all
  end

  def new
    @image = Image.new
  end

  def create
    @image = Image.new(image_params)
    @image.user_id = current_user.id

    begin
      @image.transaction do
binding.pry
        @image.save
      end
    rescue
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
