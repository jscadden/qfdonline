class UsersController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create, :verify,]
  before_filter :require_user, :only => [:show, :edit, :update,]
  
  def new
    set_invitation_email_if_present
    @user = User.new(params[:user])
  end
  
  def create
    @user = User.new(params[:user])
    verify_user_if_email_matches_invitation

    if @user.save_without_session_maintenance
      set_successful_flash_notice
      if @user.verified?
        log_user_in
        redirect_back_or_default root_path
      else
        redirect_to login_path
      end
      clear_invitation_email
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


  private

  def set_invitation_email_if_present
    if !session[:recipient_email].blank?
      params[:user] ||= {}
      params[:user].reverse_merge!(:email => session[:recipient_email])
    end
  end

  # If the user followed a link in an invitation email, then
  # session[:recipient_email] should be set to the email of the invitation.
  # If the user registers using the same email, then they are verified, since
  # we assume they must have access to said email account in order to have the
  # invitation URL.
  def verify_user_if_email_matches_invitation
    if !session[:recipient_email].blank? && 
        session[:recipient_email] == @user.email
      @user.verified_at = Time.now
    end
  end

  def log_user_in
    UserSession.create(@user)
  end

  def set_successful_flash_notice
    flash[:notice] = "Thank you for registering."
    if !@user.verified?
      flash[:notice] += " We've sent you an email with instructions for verifying your registration."
    end
  end

  def clear_invitation_email
    session.delete(:recipient_email) if session.include?(:recipient_email)
  end
end
