#Exists so that Cucumber and Webrat can access test files.  
#Otherwise, identical to storing these files in /public/tests/

class TestsController < ApplicationController
  # GET /tests/foo.csv
  def show
    render :file => '/tests/' + params[:path]
  end

end
