class RequirementsListsController < ApplicationController
  before_filter :require_user
  filter_resource_access :additional_member => {:sort => :show,}

  def sort
    @requirements_list.sort(params[:by], /asc/i === params[:order])

    redirect_to :back
  end

  # used to destroy multiple selected requirements
  def update
    respond_to do |format|
      format.js {update_js}
    end
  end


  private

  def update_js
    if @requirements_list.update_attributes(params[:requirements_list])
      render_reload
    else
      render_error("Error updating requirements list", 
                   @requirements_list.errors.full_messages.join("\n"))
    end
  end
end
