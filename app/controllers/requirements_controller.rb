class RequirementsController < ApplicationController
  before_filter :require_user
  filter_resource_access

  def create
    @req = Requirement.new(params[:requirement])

    if @req.save
      logger.debug("Requirement saved successfully")
      render_reload
    else
      msg = @req.errors.full_messages.join("\n")
      logger.error("Error creating requirement\n#{msg}")
      render_error("Error creating requirement", msg)
    end
  end

  def update
    @req = Requirement.find(params[:id])

    if @req.update_attributes(params[:requirement])
      logger.debug("Updated requirement #{@req}")
    else
      logger.error("Error updating requirement #{@req.errors.full_messages}")
    end

    if weight_edited?
      render :text => inner_weight_w_redirect_for(@req)
    elsif name_edited?
      render :text => inner_name_for(@req)
    elsif moved?
      render_reload
    else
      logger.error("Don't know what to render after updating " +
                   "#{params.inspect}")
      render :text => "Error"
    end
  end


  private 

  def weight_edited? 
    params[:requirement].include?(:weight)
  end

  def name_edited?
    params[:requirement].include?(:name)
  end

  def moved?
    params[:requirement].include?(:requested_position)
  end

end
