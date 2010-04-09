class RequirementsController < ApplicationController

  def update
    @req = Requirement.find(params[:id])

    if @req.update_attributes(params[:requirement])
      logger.debug("Updated requirement #{@req}")
    else
      logger.error("Error updating requirement #{@req.errors.full_messages}")
    end

    if params[:requirement].include?(:weight)
      render :text => inner_weight_for(@req)
    elsif params[:requirement].include?(:name)
      render :text => inner_name_for(@req)
    else
      logger.error("Don't know what to render after updating " +
                   "#{params.inspect}")
      render :text => "Error"
    end
  end

end
