class UsersController < ApplicationController
  ADMIN_ONLY_ACTIONS = [:index, :toggle_admin]
  before_filter :login_required, :only => ADMIN_ONLY_ACTIONS

  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  # PUT /users/id
  def toggle_admin
    @user = User.find(params[:id])

    @user.toggle_admin if @user.can_toggle_admin?

    respond_to do |format|
      if @user.save
        format.html { redirect_to(users_url, :notice => 'Admin status was toggled.', :alert => 'success?') }
        format.xml  { head :ok }
      else
        format.html { render :action => "index" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # render new.rhtml
  def new
    @user = User.new
  end
 
  def create
    logout_keeping_session!
    @user = User.new(params[:user])
    success = @user && @user.save
    if success && @user.errors.empty?
            # Protects against session fixation attacks, causes request forgery
      # protection if visitor resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset session
      self.current_user = @user # !! now logged in
      redirect_back_or_default('/')
      #flash[:notice] = "Thanks for signing up!  We're sending you an email with your activation code."
    else
      flash[:error]  = "We couldn't set up that account, sorry.  Please try again, or contact an admin (link is above)."
      render :action => 'new'
    end
  end

  # DELETE /users/id
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url, :notice => 'User was successfully deleted.') }
      format.xml  { head :ok }
    end
  end
 
  protected

  def authorized?(action = action_name, resource = nil)
    current_user.is_admin?
  end
  
end
