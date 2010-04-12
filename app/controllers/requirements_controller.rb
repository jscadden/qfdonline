class RequirementsController < ApplicationController

  def create
    @req = Requirement.new(params[:requirement])

    if @req.save
      logger.debug("Requirement saved successfully")
      render :js => "window.location = '#{request.referer}';"
    else
      logger.error("Error creating requirement")
      logger.error(@req.errors.full_messages.join("\n"))
      render :inline => "alert(\"Error creating requirement: #{@req.errors.full_messages.join("\n")}\");"
    end
  end

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
