class ImagesController < ApplicationController
  def index
  end

  def new
    @image = Images.new
  end

  def create
    @image = Images.new(image_params)

    if @image.save
      redirect_to images_index_path, notice: "The image #{@image.title} has been uploaded."
    else
      render "new"
    end
  end

  def destroy
  end


  private

  def image_params
    params.require(:images).permit(:title, :asset)
  end
end
