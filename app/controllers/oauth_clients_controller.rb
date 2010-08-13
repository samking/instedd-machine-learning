class OauthClientsController < ApplicationController
  before_filter :login_required
  before_filter :get_client_application, :only => [:show, :edit, :update, :destroy]
  
  def index
    @client_applications = current_user.client_applications
    @tokens = current_user.tokens.find :all, :conditions => 'oauth_tokens.invalidated_at is null and oauth_tokens.authorized_at is not null'
  end

  def clients
    respond_to do |format|
      format.xml  { render :xml => current_user.client_applications }
    end
  end

  def tokens
    respond_to do |format|
      format.xml  { render :xml => current_user.tokens.find(:all, :conditions => 'oauth_tokens.invalidated_at is null and oauth_tokens.authorized_at is not null') }
    end
  end

  def new
    @client_application = ClientApplication.new
  end

  def create
    @client_application = current_user.client_applications.build(params[:client_application])

    respond_to do |format|
      if @client_application.save
        format.html { redirect_to(:action => 'show', :id => @client_application.id, :notice => 'Registered the information successfully.', :alert => 'success?') }
        format.xml  { render :xml => @client_application, :status => :created }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @client_application.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def show
    respond_to do |format|
      format.html
      format.xml {render :xml => @client_application}
    end
  end

  def edit
  end
  
  def update
    if @client_application.update_attributes(params[:client_application])
      flash[:notice] = "Updated the client information successfully"
      redirect_to :action => "show", :id => @client_application.id
    else
      render :action => "edit"
    end
  end

  def destroy
    @client_application.destroy
    flash[:notice] = "Destroyed the client application registration"
    redirect_to :action => "index"
  end
  
  private
  def get_client_application
    unless @client_application = current_user.client_applications.find(params[:id])
      flash.now[:error] = "Wrong application id"
      raise ActiveRecord::RecordNotFound
    end
  end

end
