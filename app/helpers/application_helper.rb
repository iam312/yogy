module ApplicationHelper
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
              role=\"img\" aria-label=\"Textual Description\" 
              #{str}
        />"
         
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

  def link_season( season )
    return "" if season.blank?
    #seasons = [ 'spring', 'summer', 'autumn', 'winter' ]
    seasons = [ 'spring-25.png', 'summer-25.png', 'autumn-25.png', 'winter-25.png' ]
    
    image_tag( "#{seasons[ season - 1 ]}", size: "16x16" )
  end

  def link_season_with_yogy( season, yogy )
    return "" if (season.blank? or yogy.blank?)
    seasons_name = [ 'spring', 'summer', 'autumn', 'winter' ]
    seasons = [ 'spring-25.png', 'summer-25.png', 'autumn-25.png', 'winter-25.png' ]
    
    link_to image_tag( "#{seasons[ season - 1 ]}", size: "16x16" ), yogy_season_path( yogy, seasons_name[season - 1] )
  end

  def link_year( year )
    year
  end

end
