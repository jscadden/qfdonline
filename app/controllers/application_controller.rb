# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include ExceptionNotification::Notifiable

  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  filter_parameter_logging :password, :password_confirmation, :uservoice_api_key
  helper_method :current_user_session, :current_user, :logged_in?
  helper_method :inner_rating_for, :inner_name_for, :inner_weight_for

  before_filter :set_current_user_for_model_authorization


  protected

  def permission_denied
    render :template => "/common/permission_denied", :status => 403
  end


  private

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.user
  end

  def require_user
    unless current_user
      if request.xhr?
        login_required_ajax
      else
        login_required
      end
      return false
    end
  end

  def login_required_ajax
    render :text => "403 Permission denied", :status => 403
  end

  def login_required
    store_location
    flash[:notice] = "You must be logged in to access this page"
    redirect_to login_path
  end

  def require_no_user
    if current_user
      store_location
      flash[:notice] = "You must be logged out to access this page"
      redirect_to account_url
      return false
    end
  end
  
  def store_location
    session[:return_to] = request.request_uri
  end
  
  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

  def logged_in?
    !current_user.nil?
  end

  def inner_rating_for(rating)
    render_to_string(:partial => "/common/inner_rating_for", 
                     :locals => {
                       :rating => rating || Rating.new,
                     })
  end

  def inner_rating_w_redirect_for(rating)
    render_to_string(:partial => "/common/redirect_to_referer") +
    render_to_string(:partial => "/common/inner_rating_for", 
                     :locals => {
                       :rating => rating || Rating.new,
                     })
  end

  def inner_name_for(req)
    render_to_string(:partial => "/common/inner_name_for", 
                     :locals => {
                       :id => req.id, 
                       :name => req.errors.on(:name) ? "Error" : req.name,
                       :list_id => req.requirements_list.id,
                     })
  end

  def inner_weight_for(req)
    render_to_string(:partial => "/common/inner_weight_for",
                     :locals => {
                       :id => req.id,
                       :weight => req.errors.on(:weight) ? "Error" : req.weight,
                     })
  end

  def inner_weight_w_redirect_for(req)
    render_to_string(:partial => "/common/redirect_to_referer") +
    render_to_string(:partial => "/common/inner_weight_for",
                     :locals => {
                       :id => req.id,
                       :weight => req.errors.on(:weight) ? "Error" : req.weight,
                     }) 
  end

  def render_reload
    render :js => "window.location = '#{request.referer}';"
  end

  def render_error(title, msg)
    logger.error("Error: #{title}\n#{msg}")
    render :inline => "alert(\"#{title}:\n#{msg}\");"
  end

  def set_current_user_for_model_authorization
    Authorization.current_user = logged_in? ? current_user : nil
  end

end
