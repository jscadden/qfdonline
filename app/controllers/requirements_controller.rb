class RequirementsController < ApplicationController

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

  def destroy
    # TODO: check to make sure I own me
    @req = Requirement.find(params[:id])

    if @req.destroy
      logger.debug("Requirement destroyed successfully")
      render_reload
    else
      msg = @req.errors.full_messages.join("\n")
      logger.error("Error destroying requirement\n#{msg}")
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


  private 
  
  def render_reload
    render :js => "window.location = '#{request.referer}';"
  end

  def render_error(title, msg)
    render :inline => "alert(\"#{title}:\n#{msg}\");"
  end
end
