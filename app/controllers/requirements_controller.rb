class RequirementsController < ApplicationController
  before_filter :find_qfd
  before_filter :find_hoq

  def create
    @requirement = @hoq.requirements.build(params[:requirement])

    if @requirement.save
      flash[:notice] = "Requirement created successfully"
      redirect_to qfd_hoq_requirement_path(@qfd, @hoq, @requirement)
    else
      render :action => "new"
    end
  end

  def new
    @requirement = @hoq.requirements.build(params[:requirement])
  end

  def show
    @requirement = @hoq.requirements.find(params[:id])
  end


  private

  def find_hoq
    @hoq = @qfd.hoqs.find(params[:hoq_id])
  end

  def find_qfd
    # TODO: restrict to user
    @qfd = Qfd.find(params[:qfd_id])
  end

end
