# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController

  # render new.erb.html
  def new
  end

  def create
    authenticate_with_open_id(params[:openid_url]) do |result, identity_url|
      if result.successful?
        @user = User.find_or_create_by_identity_url(identity_url)
        @user.save if @user.new_record?
        self.current_user = @user
        successful_login
      else
        failed_login result.message
      end
    end
    #logout_keeping_session!
    #user = User.authenticate(params[:login], params[:password])
    #if user
    #  # Protects against session fixation attacks, causes request forgery
    #  # protection if user resubmits an earlier form using back
    #  # button. Uncomment if you understand the tradeoffs.
    #  # reset_session
    #  self.current_user = user
    #  new_cookie_flag = (params[:remember_me] == "1")
    #  handle_remember_cookie! new_cookie_flag
    #  redirect_back_or_default('/')
    #  flash[:notice] = "Logged in successfully"
    #else
    #  note_failed_signin
    #  @login       = params[:login]
    #  @remember_me = params[:remember_me]
    #  render :action => 'new'
    #end
  end

  def destroy
    logout_killing_session!
    flash[:notice] = "You have been logged out."
    redirect_back_or_default('/')
  end

protected
  # Track failed login attempts
  def note_failed_signin
    flash[:error] = "Couldn't log you in as '#{params[:login]}'"
    logger.warn "Failed login for '#{params[:login]}' from #{request.remote_ip} at #{Time.now.utc}"
  end

private
  def successful_login
    session[:user_id] = @current_user.id
    redirect_to(root_url)
  end

  def failed_login(message)
    flash[:error] = message
    redirect_to(new_session_url)
  end

end
