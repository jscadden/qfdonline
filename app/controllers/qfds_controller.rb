class QfdsController < ApplicationController
  before_filter :require_user

  def index
    @qfds = current_user.qfds.all
  end

  def show
    @qfd = current_user.qfds.find(params[:id])
  end

  def new
    @qfd = current_user.qfds.new(params[:qfd])
  end

  def edit
    @qfd = current_user.qfds.find(params[:id])
  end

  def create
    @qfd = current_user.qfds.new(params[:qfd])

    if @qfd.save
      flash[:notice] = 'QFD was successfully created.'
      redirect_to(@qfd) 
    else
      render :action => "new" 
    end
  end

  def update
    @qfd = current_user.qfds.find(params[:id])

    if @qfd.update_attributes(params[:qfd])
      flash[:notice] = 'QFD was successfully updated.'
      redirect_to(@qfd) 
    else
      render :action => "edit" 
    end
  end

  def destroy
    @qfd = current_user.qfds.find(params[:id])
    @qfd.destroy

    redirect_to(qfds_url)
  end
end
