class ApplicationController < ActionController::Base
  before_action :set_session_status
  #before_action :track_view

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  if Rails.env.production?
    rescue_from Exception, :with => :handle_exceptions
  end

  def login_required
    if session[:user]
      return true
    end
    flash[:warning]='Please login to continue'
    session[:return_to]=request.fullpath
    redirect_to :controller => "user", :action => "login"
    return false
  end

  def current_user
    session[:user]
  end

  def redirect_to_stored
    if return_to = session[:return_to]
      session[:return_to]=nil
      redirect_to return_to
    else
      redirect_to home_path
    end
  end

  def set_logged_user user
    session[:user] = user.id
    session[:email] = user.email
  end

  def clear_logged_user
    session[:user] = nil
  end

  def get_logged_user
    return nil if not session[:user]
    return User.find session[:user]
  end

  def render_404

    respond_to do |format|
      format.html { render :template => "index/error404", :status => :not_found }
      format.json  { head :not_found }
      format.xml  { head :not_found }
      format.any  { head :not_found }
    end

  end

  def get_session_tracking_key
    require 'uuidtools'

    if not session[:tracking_key]
      session[:tracking_key] = UUIDTools::UUID.random_create.to_s
    end

    session[:tracking_key]
  end

  private
  def handle_exceptions(e)
    ErrorMailer.experror(e, request.original_url).deliver
    render :template => "index/error500", :status => 500
  end

  def set_session_status
    if session[:user]
      @login_required = false
    else
      @login_required = true
    end

  end

  def track_view
    begin
      track = Tracking.new

      track.date = Time.now
      track.referal = request.referer
      track.url = request.original_url
      track.format = request.format.to_s
      track.user_agent = request.user_agent
      track.session = self.get_session_tracking_key

      track.save
    rescue => ex
      ErrorMailer.experror(ex, request.original_url).deliver
    end
  end

end
