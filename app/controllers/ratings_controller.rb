class RatingsController < ApplicationController
  before_filter :require_user
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

  def render_success
    render :text => inner_rating_w_redirect_for(@rating)
  end

end
