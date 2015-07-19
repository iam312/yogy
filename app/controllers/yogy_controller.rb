class YogyController < ApplicationController
  def index
    #@yogies = Yogies.all.reverse
    @yogies = Yogies.by_count
  end

  def index_v2
    @yogies = Yogies.by_count
  end

  def index_v3
    @yogies = Yogies.by_count
  end

  def index_v4
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
    title = params[:title]
    season = case params[:season]
      when 'all' then nil
      when 'spring' then 1
      when 'summer' then 2
      when 'autumn' then 3
      when 'winter' then 4
      else nil
    end
    year = params[:year]
    @yogies = Yogies.by_title( title, season, year )
    @extra = Yogies.extra( @yogies )
  end

  def delete
  end

  def about
  end
end
