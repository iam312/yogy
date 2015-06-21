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
    seasons = [ 'spring', 'summer', 'autumn', 'winter' ]
    seasons[ season - 1 ]
  end

  def link_year( year )
    year
  end

end
