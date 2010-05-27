class InvitationsController < ApplicationController

  def new
    @invitation = Invitation.new(params[:invitation])
  end

  def create
    @invitation = Invitation.new(params[:invitation])
    @invitation.sender = current_user
    @invitation.url = qfd_url(@invitation.qfd, :token => @invitation.token)

    if @invitation.save
      flash[:notice] = "Invitation sent"
      redirect_to(@invitation.qfd)
    else
      render :action => "new"
    end
  end

end
