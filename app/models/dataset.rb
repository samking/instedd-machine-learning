require 'csv'
require 'open-uri'
require 'database_interface'

class Dataset < ActiveRecord::Base
  include MachineLearningConstants

  belongs_to :user

  def database_table
    @database_table ||= DatabaseInterface.new(table_uuid)
  end

  #sets up the online database
  after_create :create_remote_database
  before_destroy :remove_remote_database

  #table_uuid can never change
  before_validation_on_create :generate_table_uuid
  attr_readonly :table_uuid, :user_id

  def self.purge_remote_databases
    Dataset.all.each do |dataset|
      DatabaseInterface.delete_table dataset.table_uuid
    end
  end

  #TODO: ask machine learning services if we're still learning
  def is_learning?
    false
  end

  def self.make_calais_request(content, type, function_call)
    response = Calais.method(function_call).call(:content => content, 
                                      :content_type => type, 
                                      :license_id => $user_config[:calais_key]
                                     ) do |curl_client|
      #the Calais class makes a call to Curb's version of libcurl, which, by
      #default, sends an "Expect: 100" on any posts longer than 1024 bytes.
      #This block ensures that the Calais Client already has that code disabled
      #by giving the Calais Client a Curl instance with that header disabled.
      curl_client.instance_eval do 
        @client = Curl::Easy.new
        @client.headers["Expect"] = ''
      end
    end
  end

  def self.learn_from_calais(rows, type=:html, function_call=:enlighten)
      rows = [rows] if not rows.respond_to? :pmap #assumes that there is one element

      #calais doesn't have an API for batch processing, so in order to run a
      #request on each element, we want to run them in parallel
      rows.pmap([NUM_CALAIS_THREADS, rows.length].min) do |row| 
          make_calais_request(row, type, function_call)
      end
  end

  def self.supports_service?(service)
    service = service.to_sym
    MACHINE_LEARNING_SERVICES.include?(service)
  end

  #TODO: support parameters to specify rows, cols, and services
  def learn(service)
    service = service.to_sym
    row_names, rows = database_table.as_array
    learning_response = Dataset.method("learn_from_" + service.to_s).call(rows)
    database_table.add_ml_response(row_names, learning_response, service)
  end

  private

  def create_remote_database
    DatabaseInterface.create_table(table_uuid)
  end

  def remove_remote_database
    DatabaseInterface.delete_table(table_uuid)
  end

  def generate_table_uuid
    update_attribute(:table_uuid, UUIDTools::UUID.random_create.to_s)
  end

end

