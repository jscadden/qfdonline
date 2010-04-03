class RequirementsController < ApplicationController

  def update
    @req = Requirement.find(params[:id])

    if @req.update_attributes(params[:requirement])
      logger.debug("Updated requirement #{@req}")
      render :text => inner_name_for(@req)
    else
      logger.error("Error updating requirement #{@req.errors.full_messages}")
    end
  end

end
