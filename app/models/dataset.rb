require 'csv'
require 'open-uri'
require 'database_interface'

class Dataset < ActiveRecord::Base
  #TODO: support other machine learning services and put the machine learning interface into a class
  MACHINE_LEARNING_SERVICES = [:calais]

  #Calais only allows 4 requests per second, and if we do more than that,
  #it's slower than if we limited the requests on our end.
  #Each request takes about 2 seconds, so 8 threads should allow 4 requests
  #per second
  NUM_CALAIS_THREADS = 8

  def database_table
    @database_table ||= DatabaseInterface.new(client_uuid)
  end

  #sets up the online database
  after_create :create_remote_database
  before_destroy :remove_remote_database

  #client_uuid can never change
  before_validation_on_create :generate_client_uuid
  attr_readonly :client_uuid

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

  #TODO: support parameters to specify rows, cols, and services
  def learn(service)
    raise "#{service} not supported" unless MACHINE_LEARNING_SERVICES.include? service
    row_names, rows = database_table.as_array
    learning_response = Dataset.method("learn_from_" + service.to_s).call(rows)
    database_table.add_ml_response(row_names, learning_response, service)
  end

  private

  def create_remote_database
    DatabaseInterface.create_table(client_uuid)
  end

  def remove_remote_database
    DatabaseInterface.delete_table(client_uuid)
  end

  def generate_client_uuid
    update_attribute(:client_uuid, UUIDTools::UUID.random_create.to_s)
  end

end

