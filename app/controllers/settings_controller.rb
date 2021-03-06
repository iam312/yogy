class SettingsController < ApplicationController
  def index
  end

  def ajax_update_profile
    is_success = true

    name = params[:name].strip
    email = params[:email].strip

    begin
      raise ::Yogy::Exceptions::InternalError.new "name or email blank. current_user.id => #{current_user.id}" if name.blank? or email.blank?

      current_user.name = name
      current_user.email = email
      current_user.save!
    rescue => e
      Rails.logger.error( e )
      is_success = false
    end

    render :json => {
      is_success: is_success, 
    }
  end


  def ajax_delete_me
    is_success = true

    begin
      Image.transaction do
        Image.where( user_id: current_user.id ).update_all( deleted: 1 )
        User.destroy( current_user.id )
      end
    rescue => e
      Rails.logger.error( e )
      is_success = false
    end

    render :json => {
      is_success: is_success, 
    }
  end
end

