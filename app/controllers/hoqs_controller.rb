class HoqsController < ApplicationController
  before_filter :find_qfd, :only => ["new",]

  def create
    @hoq = Hoq.new(params[:hoq])
    @qfd = @hoq.qfd

    if @hoq.save
      flash[:notice] = "HOQ created successfully"
      redirect_to hoq_path(@hoq)
    else
      render :action => "new"
    end
  end

  def new
    @hoq = @qfd.hoqs.build(params[:hoq])
  end

  def show
    @hoq = Hoq.find(params[:id])
    @qfd = @hoq.qfd
  end

  
  private

  def find_qfd
    @qfd = Qfd.find(params[:qfd_id])
  end

end
