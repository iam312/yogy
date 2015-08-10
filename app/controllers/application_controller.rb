class ApplicationController < ActionController::Base
  include HttpAcceptLanguage::AutoLocale

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  #unless ActionController::Base.consider_all_requests_local
    rescue_from ::Yogy::Exceptions::ImageBlinded, with: :render_image_blinded
    rescue_from ::Yogy::Exceptions::ImageDeleted, with: :render_image_deleted
    rescue_from ::Yogy::Exceptions::UserDisabled, with: :render_user_disabled
  #end 


  private

  def render_image_deleted( exception )
    Rails.logger.error( exception )
    render template: "/exceptions/image_deleted.html.erb", status: 404
  end

  def render_image_blinded( exception )
    Rails.logger.error( exception )
    render template: "/exceptions/image_blinded.html.erb", status: 404
  end

  def render_user_disabled( exception )
    Rails.logger.error( exception )
    render template: "/exceptions/user_disabled.html.erb", status: 404
  end

end
