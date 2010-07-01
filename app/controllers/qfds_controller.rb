class QfdsController < ApplicationController
  before_filter :require_user, :except => [:show,]
  filter_resource_access :additional_member => [:download,]

  def create
    if @qfd.save
      flash[:notice] = 'QFD was successfully created.'
      redirect_to(@qfd) 
    else
      render :action => "new" 
    end
  end

  def destroy
    if @qfd.destroy
      flash[:notice] = "QFD deleted successfully"
    else
      logger.error("Error deleting QFD #{@qfd.inspect}")
      flash[:error] = "Error deleting QFD"
    end
    redirect_to(qfds_url)
  end

  def download
    send_file @qfd.to_xls.path
  end

  def index
    @my_qfds, @invited_qfds = Qfd.with_permissions_to(:read).find(:all).partition {|q| q.user == current_user}
  end

  def show
    redirect_to [@qfd, @qfd.hoqs.first]
  end

  def update
    if @qfd.update_attributes(params[:qfd])
      flash[:notice] = 'QFD was successfully updated.'
      redirect_to(@qfd) 
    else
      render :action => "edit" 
    end
  end


  protected

  def new_qfd_from_params
    @qfd = current_user.qfds.new(params[:qfd])
  end

  def new_qfd_for_collection
    @qfd = current_user.qfds.new(params[:qfd])
  end
end
