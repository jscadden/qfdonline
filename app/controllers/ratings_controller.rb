class RatingsController < ApplicationController
  before_filter :require_user
  before_filter :find_rating, :only => [:update, :destroy,]
  filter_resource_access

  def create
    @rating = Rating.new(params[:rating])

    if @rating.save
      render_success
    else
      render :text => "Error"
      logger.error("Rating#create failed")
    end
  end

  def update
    if @rating.update_attributes(params[:rating])
      render_success
    else
      render :text => "Error"
      logger.error("Rating#update failed")
    end
  end

  def destroy
    if @rating.destroy
      @rating = Rating.new(@rating.attributes.merge(:value => nil))
      render_success
    else
      render :text => "Error"
      logger.error("Rating#destroy failed")
    end
  end


  private

  def find_rating
    @rating = Rating.find(params[:id])
    unless current_user.owns_rating?(@rating)
      raise ActiveRecord::RecordNotFound.new
    end
  end

  def render_success
    render :text => inner_rating_w_redirect_for(@rating)
  end

end
