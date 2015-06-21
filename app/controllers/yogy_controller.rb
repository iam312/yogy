class YogyController < ApplicationController
  def index
    #@yogies = Yogies.all.reverse
    @yogies = Yogies.by_count
  end

  def index_v2
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
    @yogies = Yogies.by_title( params[:title] )
    @extra = Yogies.extra( @yogies )
  end

  def delete
  end

  def about
  end
end
