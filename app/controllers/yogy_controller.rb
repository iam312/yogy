class YogyController < ApplicationController
  include ApplicationHelper
  include ActionView::Helpers::OutputSafetyHelper
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::TextHelper

  def index
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
    @next_offset = ENV["LIST_LIMIT"].to_i

    yogies = _load_more_yogies( 0, 9999999 )
    @extra = Yogies.extra( yogies )
    @yogies = yogies.offset(0).limit(ENV["LIST_LIMIT"].to_i )
  end

  def delete
  end

  def about
  end

  def _load_more_yogies( offset, limit = ENV["LIST_LIMIT"].to_i )
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
    Yogies.by_title( title, season, year ).offset(offset).limit(limit)
  end

  def ajax_load_more
    is_success = true
    images = []
    html = ""
    next_offset = 0
    begin
      offset = params[:offset].to_i
      next_offset = params[:offset].to_i + ENV["LIST_LIMIT"].to_i

      method = "_load_more_#{params[:method]}"
      yogies = send(method, *[offset])

      fp = File.open( "app/views/yogy/_list.html.erb" )
      template = fp.read
      fp.close
      
      html = ERB.new(template).result(binding)
    rescue => e
      Rails.logger.error(e)
      is_success = false
    end

    render :json => {
      is_success: is_success,
      html: html,
      next_offset: next_offset
    }
  end
end
