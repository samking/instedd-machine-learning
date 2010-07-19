require 'csv'
require 'open-uri'


class Dataset < ActiveRecord::Base
  #TODO: support other database services and put the database interface into a class
  @@sdb = Aws::SdbInterface.new($user_config[:sdb_user], $user_config[:sdb_pass])
  def self.sdb
    @@sdb
  end

  SDB_MAX_NUM_CHUNKS = 256
  #the first 3 characters are the chunk identifier
  SDB_MAX_CHUNK_SIZE = 1024 - 3

  #TODO: support other machine learning services and put the machine learning interface into a class
  MACHINE_LEARNING_SERVICES = [:calais]

  #Calais only allows 4 requests per second, and if we do more than that,
  #it's slower than if we limited the requests on our end.
  #Each request takes about 2 seconds, so 8 threads should allow 4 requests
  #per second
  NUM_CALAIS_THREADS = 8

  #validation
  validates_uniqueness_of :uid
  validates_length_of :uid, :minimum => 3
  validate_on_create :must_not_duplicate_database_tables 

  #sets up the online database
  after_create :create_remote_database
  before_destroy :remove_remote_database

  #uid can never change
  attr_readonly :uid

  #TODO: support formats other than csv
  #TODO: support csv without header (specify noheader by parameter)
  def add_data(data_url)
    reader = CSV::Reader.create(open(data_url))
    header = reader.shift

    items = []
    reader.each do |row| 
      attributes = {}
      header.zip(row) do |col_head, col|
        attributes[col_head] = chunk_sdb_attribute(col)
      end
      items << Aws::SdbInterface::Item.new(UUIDTools::UUID.timestamp_create, attributes)
    end
    @@sdb.batch_put_attributes(uid, items)
  end

  def num_attributes_remaining item_name
    num_attributes_used = @@sdb.get_attributes(uid, item_name)[:attributes].length
    return SDB_MAX_NUM_CHUNKS - num_attributes_used
  end

  #each attribute value stored in a SDB database can only be 
  #SDB_MAX_CHUNK_SIZE bytes However, each attribute can hold 
  #multiple values.  
  #This function splits one value into several associated with
  #one attribute.
  def chunk_sdb_attribute attribute
    return unless attribute
    total_length = attribute.length
    used_length = 0
    chunk_number = 1
    chunked_attribute = []
    remaining_attribute = attribute
    while used_length < total_length
      current_chunk = ("%03d" % chunk_number) + attribute[0...SDB_MAX_CHUNK_SIZE]
      chunked_attribute << current_chunk
      remaining_attribute =  remaining_attribute[SDB_MAX_CHUNK_SIZE..-1]
      used_length += SDB_MAX_CHUNK_SIZE
    end
    chunked_attribute
  end

  def unchunk_sdb_attribute
    #TODO: implement
  end

  def add_response_to_database(database, learning_response, service)
    items = []
    database[0].zip(learning_response) do |row_name, ml_response|
      items << Aws::SdbInterface::Item.new(row_name, {"ml_#{service}:#{Time.new}" => chunk_sdb_attribute(ml_response)})
    end
    @@sdb.batch_put_attributes(uid,items)
  end

  #TODO: ask machine learning services if we're still learning
  def is_learning?
    false
  end

  def get_database(reassemble=true)
    keys = []
    items = []
    @@sdb.select("select * from #{uid}")[:items].each do |item|
      item.each do |key, val|
        keys << key
        items << val
      end
    end
    return keys, items
  end

  def get_items(reassemble=true)
    get_database[1]
  end

  def self.get_domain_list_string
    @@sdb.list_domains[:domains].inspect
  end

  def self.hash_to_xml(hash, builder=Builder::XmlMarkup.new)
    builder.item {
      hash.each do |key, value|
        eval "builder.#{key}('#{value}')"
      end
    }
    builder.target!
  end

  def sdb_to_xml
    items = get_items
    builder = Builder::XmlMarkup.new
    items.each do |item|
      hash_to_xml(item, builder)  
    end
    builder.target!
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
    database = get_database
    learning_response = Dataset.method("learn_from_" + service.to_s).call(database[1])
    add_response_to_database(database, learning_response, service)
  end

  private

  def create_remote_database
    @@sdb.create_domain(uid)
  end

  def remove_remote_database
    @@sdb.delete_domain(uid)
  end

  def must_not_duplicate_database_tables 
    errors.add :uid , 'already in remote database.' if @@sdb.list_domains[:domains].include?(uid)
  end
end

