class RequirementsController < ApplicationController
  before_filter :find_hoq, :only => ["new",]

  def create
    @requirement = Requirement.new(params[:requirement])
    @hoq = @requirement.hoq
    @qfd = @hoq.qfd

    if @requirement.save
      flash[:notice] = "Requirement created successfully"
      redirect_to requirement_path(@requirement)
    else
      render :action => "new"
    end
  end

  def new
    @requirement = @hoq.requirements.build(params[:requirement])
  end

  def show
    @requirement = Requirement.find(params[:id])
    @hoq = @requirement.hoq
    @qfd = @hoq.qfd
  end


  private

  def find_hoq
    @hoq = Hoq.find(params[:hoq_id])
  end

end
