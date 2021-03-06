class ImagesController < ApplicationController
  include ApplicationHelper
  include ActionView::Helpers::OutputSafetyHelper
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::TextHelper

  before_action :authenticate_user!, only: [:new, :create, :destroy, :ajax_save_yogies, :ajax_save_description,
                                            :image_like, :image_dislike, :image_cancel_like, :image_cancel_dislike,]
  before_action :showable!, only: [:show, ]

  def index
    @next_offset = ENV["LIST_LIMIT"].to_i
    @images = _load_more_all_images(0)
  end

  def new
    @image = params[:image].blank? ? Image.new : Image.new(image_params)
  end

  def create
    @image = Image.new(image_params)
    @image.user_id = current_user.id

    begin
      raise ::Yogy::Exceptions::ImageInvalid.new "image is not setted." if image_params[:s3].blank?
      @image.transaction do
        @image.save!

        #@image.delay.process!( current_user )
        @image.process!( current_user )
      end
    rescue => e
      Rails.logger.error e
      flash[:error] = I18n.t( 'error.fail_to_regist_photo' )
      render "new"
      return
    end
    redirect_to image_path( @image ), notice: "The photo #{@image.yogies} has been uploaded."
  end

  def destroy
    is_success = true
    begin
      image = Image.find params[:id]
      if image.user_id == current_user.id
        image.deleted = 1 
        image.save!
      end
    rescue
      is_success = false
    end

    render :json => {
      is_success: is_success
    }
  end

  def show
    id = params[:id].to_i
    nav = params[:nav]
    unless nav.blank?
      if nav == "prev"
        id = Image.get_prev_image_id( id ).first.andand.id || Image.first.id
      else
        id = Image.get_next_image_id( id ).first.andand.id || Image.last.id
      end
    end
    
    Image.increment_counter( :view_count, id )
    @image = Image.find_by_id( id )
  end

  def _load_more_all_images( offset, limit = ENV["LIST_LIMIT"].to_i )
    Image.all_images( offset, limit)
  end

  def _load_more_filter_by_user( offset, limit = ENV["LIST_LIMIT"].to_i  )
    Image.filter_by_user( params[:user_id], offset, limit )
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
      images = send(method, *[offset])

      fp = File.open( "app/views/images/_list.html.erb" )
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

  def ajax_save_yogies
    is_success = true
    updated_yogies_html = ""
    begin
      image = Image.find_by_id params[:id]
      if image.nil?
        is_success = false
      else
        yogies = params[:field_yogies]
        unless image.yogies == yogies
          image.update_yogies!( current_user, yogies )
          updated_yogies_html = link_yogies_with_picture_count( image )
        end
      end
    rescue => e
      is_success = false
    end

    render :json => {
      is_success: is_success,
      html: updated_yogies_html,
    }
  end

  def ajax_save_description
    is_success = true
    begin
      image = Image.find_by_id params[:id]
      if image.nil?
        is_success = false
      else
        unless image.desc == params[:desc]
          image.desc = params[:desc] 
          image.save
        end
      end
    rescue => e
      is_success = false
    end

    render :json => {
      is_success: is_success
    }
  end

  def ajax_like
    is_success = true
    like_count = 0
    begin
      Liker.transaction do
        image_id = params[:id]
        image = Image.find_by_id image_id
        raise ::Yogy::Exceptions::AlreadyLiked.new "already liked. current_user.id => #{current_user.id}, image_id => #{image.id}" if Liker.where( { user_id: current_user.id, image_id: image_id } ).count > 0
        Liker.new( {user_id: current_user.id, image_id: image_id} ).save!
        like_count = image.increment( :like ).like
        image.save!
      end
    rescue => e
      Rails.logger.error( e )
      is_success = false
    end
    render :json => {
      is_success: is_success, 
      like_count: like_count
    }
  end

  def ajax_dislike
    is_success = true
    dislike_count = 0
    begin
      Disliker.transaction do
        image_id = params[:id]
        image = Image.find_by_id image_id
        raise ::Yogy::Exceptions::AlreadyDisliked.new "already disliked. current_user.id => #{current_user.id}, image_id => #{image.id}" if Liker.where( { user_id: current_user.id, image_id: image_id } ).count > 0
        Disliker.new( {user_id: current_user.id, image_id: image_id} ).save!
        dislike_count = image.increment( :dislike ).dislike
        image.save!
      end
    rescue => e
      Rails.logger.error( e )
      is_success = false
    end
    render :json => {
      is_success: is_success, 
      dislike_count: dislike_count
    }
  end

  def ajax_cancel_like
  end

  def ajax_cancel_dislike
  end


  def filter_by_user
    @next_offset = ENV["LIST_LIMIT"].to_i
    images = _load_more_filter_by_user( 0, 9999999 )
    @yogies_string = Image.generate_yogies_with_images( images ).map{ |v| "##{v}" }.join(",")
    @images = images.offset(0).limit(@next_offset)
    @user = User.find params[:user_id]
  end


  private
  
  def showable!
    image = Image.find_by_id params[:id]
    raise ::Yogy::Exceptions::UserDisabled.new "image_id #{params[:id]}'s user is disabled" if image.user_disabled?
    raise ::Yogy::Exceptions::ImageDeleted.new "image_id #{params[:id]} is deleted" if image.deleted?
    raise ::Yogy::Exceptions::ImageBlinded.new "image_id #{params[:id]} is blinded" if image.blinded?
  end

  def image_params
    params.require(:image).permit!
  end
end
