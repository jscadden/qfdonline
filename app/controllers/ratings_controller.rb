class RatingsController < ApplicationController

  def create
    @rating = check_for_existing_rating || Rating.new

    if @rating.update_attributes(params[:rating])
      render :text => inner_rating_for(@rating.primary_requirement,
                                       @rating.secondary_requirement,
                                       @rating.value)
    else
      logger.error("Rating failed")
    end
  end


  private

  def check_for_existing_rating
    Rating.lookup(params[:rating][:primary_requirement_id],
                  params[:rating][:secondary_requirement_id])
  end



end
