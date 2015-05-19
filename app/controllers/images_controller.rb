class ImagesController < ApplicationController
  def index
  end

  def new
    @image = Image.new
  end

  def create
    @image = Image.new(image_params)
    @image.user_id = current_user.id

    if @image.save
      redirect_to image_path({id: @image.id }), notice: "The image #{@image.title} has been uploaded."
    else
      render "new"
    end
  end

  def destroy
  end

  def show
    @image = Image.find_by_id( params[:id] )
  end


  private

  def image_params
    params.require(:image).permit(:title, :asset, :user_id)
  end
end
