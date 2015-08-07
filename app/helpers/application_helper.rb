module ApplicationHelper
  SEASONS_TEXT = [ 'spring', 'summer', 'autumn', 'winter' ]
  SEASONS_ING = [ 'spring-25.png', 'summer-25.png', 'autumn-25.png', 'winter-25.png' ]

  def responsive_image_tag( *argvs )
    image = nil
    etc = {}
    argvs.each do | argv |
      image = argv if argv.respond_to? :s3 ## is image model
      etc = argv if argv.respond_to? :keys  ## is hash?
    end

    str = ""
    etc.each do |k, v|
      str += " #{k}='#{v}'" 
    end

    raw "<img src=\"\" 
              data-src-xsmall=\"#{Rails.application.routes.url_helpers.dn_path(image, 'xsmall')}\" 
              data-src-small=\"#{Rails.application.routes.url_helpers.dn_path(image, 'small')}\" 
              data-src-normal=\"#{Rails.application.routes.url_helpers.dn_path(image, 'normal')}\" 
              data-src-orig=\"#{Rails.application.routes.url_helpers.dn_path(image, 'orig')}\" 
              role=\"img\" aria-label=\"\" 
              #{str}
        />"
         
  end

  def dn_url( image, target )
    "#{request.base_url}/dn/#{image.id}/#{target}"
  end

  def alert_devise_to_bootstrap( devise )
    alert_type = {"alert": "warning", "notice": "success", "error": "danger"}
    alert_type[devise.to_sym]
  end

  def link_yogies( yogies_string )
    result = ""
    yogies = yogies_string.split(",")
    yogies.each_with_index do |yogy, idx|
      result += link_to( yogy.strip, yogy_path( yogy.strip.gsub('#', '') ) )
      result += ", " if idx + 1 < yogies.size
    end

    result
  end

  def link_yogies_with_picture_count( yogies )
    result = "<h3>"
    yogies.each_with_index do | item, idx |
      yogy = item[0]
      extra = item[1]
      result += "#{link_to( yogy.strip, yogy_path( yogy.strip.gsub('#', '') ) )}"
      result += "<sup><span class='badge'>#{extra[:count] - 1}</span></sup> " if extra[:count] > 1
      seasons = ""
      extra[:seasons].each_with_index do |season, idx|
        seasons += link_season_text( season - 1 )
        seasons += ", " if idx + 1 < extra[:seasons].size
      end
      result += "<small>#{seasons} | </small>" unless seasons.blank?

      years = ""
      extra[:years].each_with_index do |year, idx|
        years += year.to_s
        years += ", " if idx + 1 < extra[:years].size
      end
      result += "<small>#{years}</small>" unless years.blank?
      result += ", " if idx + 1 < yogies.size
    end

    result + "</h3>"
  end

  def link_season( season )
    return "" if season.blank?
    image_tag( "#{SEASONS_ING[ season - 1 ]}", size: "16x16" )
  end

  def link_season_text( season )
    return "" if season.blank?
    I18n.t( "common.season.#{SEASONS_TEXT[ season - 1 ]}" )
  end

  def link_season_with_yogy( season, yogy )
    return "" if (season.blank? or yogy.blank?)
    seasons_name = [ 'spring', 'summer', 'autumn', 'winter' ]
    seasons = [ 'spring-25.png', 'summer-25.png', 'autumn-25.png', 'winter-25.png' ]
    
    #link_to image_tag( "#{seasons[ season - 1 ]}", size: "16x16", class: "yogy_hand yogy_tone" ), yogy_season_path( yogy, seasons_name[season - 1] )
    link_to seasons_name[season - 1], yogy_season_path( yogy, seasons_name[season - 1] )
  end

  def link_year( year )
    year
  end

  def link_year_with_yogy( year, yogy )
    link_to year, yogy_year_path( yogy, year )
  end

end
