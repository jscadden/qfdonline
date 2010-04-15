class RequirementsListsController < ApplicationController
  
  def sort
    @list = RequirementsList.find(params[:id])

    @list.sort(params[:by], /asc/i === params[:order])

    redirect_to :back
  end

end
