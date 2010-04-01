class HoqsController < ApplicationController
  before_filter :require_user
  before_filter :find_qfd

  def create
    @hoq = Hoq.new(params[:hoq])

    if @qfd.hoq_list.insert_back(@hoq)
      flash[:notice] = "HOQ created successfully"
      redirect_to [@qfd, @hoq]
    else
      render :action => "new"
    end
  end

  def index
    @hoqs = @qfd.hoqs.all
  end

  def new
    @hoq = @qfd.hoqs.build(params[:hoq])
  end

  def show
    @hoq = @qfd.hoqs.find(params[:id], :include => [:primary_requirements, :secondary_requirements,])
  end


  private

  def find_qfd
    @qfd = current_user.qfds.find(params[:qfd_id])
  end

end
