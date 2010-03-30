class HoqsController < ApplicationController
  before_filter :find_qfd

  def create
    @hoq = @qfd.hoqs.build(params[:hoq])

    if @hoq.save
      flash[:notice] = "HOQ created successfully"
      redirect_to [@qfd, @hoq]
    else
      render :action => "new"
    end
  end

  def new
    @hoq = @qfd.hoqs.build(params[:hoq])
  end

  def show
    @hoq = @qfd.hoqs.find(params[:id])
  end


  private

  def find_qfd
    # TODO: restrict to user
    @qfd = Qfd.find(params[:qfd_id])
  end
end
