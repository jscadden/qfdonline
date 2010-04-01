class SecondaryRequirementsController < ApplicationController
  before_filter :require_user
  before_filter :find_hoq
  before_filter :find_list

  def create
    # counter-intuitively, @hoq.secondary_requirements.build will not work here
    @req = @list.requirements.build(params["requirement"])

    if @req.save
      flash[:notice] = "Secondary requirement created successfully"
      redirect_to([@hoq.qfd, @hoq])
    else
      render :action => "new"
    end
  end

  def new
    # counter-intuitively, @hoq.secondary_requirements.build will not work here
    @req = @list.requirements.build(params["requirement"])
  end


  private

  def find_hoq
    @hoq = Hoq.find(params[:hoq_id])
    unless current_user.qfds.include?(@hoq.qfd)
      raise ActiveRecord::RecordNotFound.new
    end
  end

  def find_list
    @list = @hoq.secondary_requirements_list
  end
end
