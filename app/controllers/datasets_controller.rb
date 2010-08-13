class DatasetsController < ApplicationController
  include MachineLearningConstants

  MEMBER_ACTIONS = [:show, :update, :destroy]
  ADMIN_ONLY_ACTIONS = [:cleanup]
  before_filter :fetch_dataset, :only => MEMBER_ACTIONS
  before_filter :login_or_oauth_required

  # GET /datasets
  # GET /datasets.xml
  def index
    if current_user.is_admin?
      @datasets = Dataset.all
    else
      #Each user can only see their own datasets
      @datasets = Dataset.all(:conditions => {:user_id => current_user.id})
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @datasets }
    end
  end

  # GET /datasets/1
  # GET /datasets/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  # show.xml.builder
    end
  end

  # GET /datasets/new
  # GET /datasets/new.xml
  def new
    @dataset = Dataset.new

    respond_to do |format|
      format.html # new.html.erb
      #format.xml  { render :xml => @dataset }
    end
  end

  # POST /datasets
  # POST /datasets.xml
  def create
    @dataset = current_user.datasets.build(params[:dataset])

    respond_to do |format|
      if @dataset.save
        format.html { redirect_to(@dataset, :notice => 'Dataset was successfully created.', :alert => 'success?') }
        format.xml  { render :xml => @dataset, :status => :created, :location => @dataset }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @dataset.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /datasets/1
  # PUT /datasets/1.xml
  def update
    @dataset.database_table.remove_data(params[:remove_rows], params[:remove_cols]
                        ) unless params[:remove_rows].blank? #it's ok if removecols is blank
    @dataset.database_table.add_data(params[:data_url]) unless params[:data_url].blank?
    if not params[:service].blank?
      if Dataset.supports_service?(params[:service])
        @dataset.learn(params[:service].intern)
      else
        head :unprocessable_entity and return
      end
    end

    respond_to do |format|
      if @dataset.update_attributes(params[:dataset])
        format.html { redirect_to(@dataset, :notice => 'Dataset was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @dataset.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /datasets/1
  # DELETE /datasets/1.xml
  def destroy
    @dataset.destroy

    respond_to do |format|
      format.html { redirect_to(datasets_url, :notice => 'Dataset was successfully deleted.') }
      format.xml  { head :ok }
    end
  end
  
  # DELETE /datasets/cleanup
  # DELETE /datasets/cleanup.xml
  # For when the remote databases get out of sync with the local database
  # and it is necessary to manually remove elements from them
  def cleanup
    DatabaseInterface.delete_table(params[:table_to_remove]) unless params[:table_to_remove].blank?

    respond_to do |format|
      format.html { redirect_to(datasets_url, :notice => 'Remote table was successfully deleted.') }
      format.xml  { head :ok }
    end
  end

  protected 

  def authorized?(action = action_name, resource = nil)
    user = nil
    if oauth?
      user = User.find(current_token[:user_id])
      self.current_user=(user)
    else
      return false unless logged_in?
      user = current_user
    end
    return true if user.is_admin?
    return false if ADMIN_ONLY_ACTIONS.include? action
    if MEMBER_ACTIONS.include? action.to_sym
      return user.id == @dataset.user_id
    end
    return true
  end

  private

  def fetch_dataset
    @dataset = Dataset.find(params[:id])
  end

end
