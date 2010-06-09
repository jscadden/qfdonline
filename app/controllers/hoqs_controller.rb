class HoqsController < ApplicationController
  before_filter :require_user
  before_filter :find_qfd

  def create
    @hoq = @qfd.hoqs.new(params[:hoq])

    if @qfd.hoq_list.insert_back(@hoq)
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
    @hoq = @qfd.hoqs.find(params[:id], :include => [:primary_requirements, 
                                                    :secondary_requirements,])
  end

  
  private

  def find_qfd
    @qfd = Qfd.with_permissions_to(:read).find(params[:qfd_id])
  end

end
