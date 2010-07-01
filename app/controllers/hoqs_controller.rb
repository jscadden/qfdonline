class HoqsController < ApplicationController
  before_filter :require_user, :except => [:show,]
  filter_resource_access :nested_in => :qfds

  def create
    if @qfd.hoq_list.insert_back(@hoq)
      flash[:notice] = "HOQ created successfully"
      redirect_to [@qfd, @hoq]
    else
      render :action => "new"
    end
  end


  protected

  def new_hoq_from_params
    @hoq = @qfd.hoq_list.hoqs.build(params[:hoq])
  end

end
