class QfdsController < ApplicationController
  before_filter :require_user, :except => [:show, :index, :download,]
  filter_resource_access :additional_member => {:download => :show,}

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
    if public_qfds_requested? || !logged_in?
      index_public
    else
      index_private
    end
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


  private

  def index_public
    @qfds = Qfd.public
    render :action => "index_public"
  end

  def index_private
    @my_qfds, @invited_qfds = Qfd.with_permissions_to(:show).find(:all).partition {|q| q.user == current_user}
    render :action => "index_private"
  end

  def public_qfds_requested?
    params.include?(:public) && "true" == params[:public] 
  end

end
