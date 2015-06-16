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

end
