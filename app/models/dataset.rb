require 'csv'
require 'open-uri'

class Dataset < ActiveRecord::Base

  belongs_to :user

  def database_table
    @database_table ||= DatabaseInterface.new(remote_db_service, table_uuid)
  end

  def learner
    @learner ||= MachineLearningInterface.new(database_table)
  end

  #sets up the online database
  before_create :create_remote_database
  before_destroy :remove_remote_database

  #table_uuid can never change
  before_validation_on_create :generate_table_uuid
  attr_readonly :table_uuid, :user_id

  validates_uniqueness_of :name
  validate_on_create :remote_db_service_must_be_supported  #change to validate if we add the ability to migrate or change database table

  def self.purge_remote_databases
    Dataset.all.each do |dataset|
      DatabaseInterface.delete_table(dataset.table_uuid)
    end
  end

  private

  def create_remote_database
    DatabaseInterface.create_table(remote_db_service, table_uuid)
  end

  def remove_remote_database
    DatabaseInterface.delete_table(remote_db_service, table_uuid)
  end

  def generate_table_uuid
    update_attribute(:table_uuid, UUIDTools::UUID.random_create.to_s)
  end

  def remote_db_service_must_be_supported
    errors.add(:remote_db_service, "Remote database service is not supported.  
               Supported services: 
               #{SUPPORTED_DB_SERVICES}"
              ) unless DatabaseInterface.supports_db_service(remote_db_service)
  end

end

