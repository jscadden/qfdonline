class RequirementsListsController < ApplicationController
  before_filter :require_user
  
  def sort
    @list = RequirementsList.find(params[:id])

    @list.sort(params[:by], /asc/i === params[:order])

    redirect_to :back
  end

end
