class InvitationsController < ApplicationController
  before_filter :require_user

  def show
    @invitation = Invitation.find_by_token!(params[:id])
  end

  def update
    @invitation = Invitation.find_by_token!(params[:id])
    @invitation.recipient = current_user

    if @invitation.save
      flash[:notice] = "Invitation accepted"
      redirect_to @invitation.qfd
    else
      render :action => "show"
    end
  end

  def new
    @invitation = Invitation.new(params[:invitation])
  end

  def create
    @invitation = Invitation.new(params[:invitation])
    @invitation.sender = current_user
    @invitation.url = invitation_url(@invitation)

    if @invitation.save
      flash[:notice] = "Invitation sent"
      redirect_to(@invitation.qfd)
    else
      render :action => "new"
    end
  end

end
