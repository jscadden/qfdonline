class UsersController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create, :verify,]
  before_filter :require_user, :only => [:show, :edit, :update,]
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])

    if @user.save_without_session_maintenance # don't log the user in
      flash[:notice] = "Thank you for registering.  We've sent you an email with instructions for verifying your registration."
      redirect_back_or_default root_path
    else
      render :action => :new
    end
  end
  
  def show
    @user = @current_user
  end
 
  def edit
    @user = @current_user
  end
  
  def update
    @user = @current_user # makes our views "cleaner" and more consistent
    if @user.update_attributes(params[:user])
      flash[:notice] = "Account updated!"
      redirect_to account_url
    else
      render :action => :edit
    end
  end

  def verify
    user = User.find_using_perishable_token!(params[:token])
    user.verify!
    UserSession.create!(user)
    flash[:notice] = "Thank you for verifying your registration."
    redirect_back_or_default root_path
  rescue StandardError => e
    logger.error("Error verifying registration #{e}
#{e.backtrace.join("\n")}")
    flash[:error] = "Error verifying registration"
    redirect_to root_path
  end
end
