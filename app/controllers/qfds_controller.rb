class QfdsController < ApplicationController

  def create
    @qfd = Qfd.new(params[:qfd])

    if @qfd.save
      flash[:notice] = "QFD created successfully"
      redirect_to qfd_path(@qfd)
    else
      render :action => "new"
    end
  end

  def index
    # TODO: restrict by user
    @qfds = Qfd.all
  end

  def new
    @qfd = Qfd.new(params[:qfd])
  end

  def show
    # TODO: restrict by user
    @qfd = Qfd.find(params[:id])
  end
end
