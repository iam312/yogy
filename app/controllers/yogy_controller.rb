class YogyController < ApplicationController
  def index
    #@yogies = Yogies.all.reverse
    @yogies = Yogies.by_count
  end

  def new 
    @yogy = Yogies.new
  end

  def edit
  end

  def update
  end

  def show
  end

  def delete
  end
end
