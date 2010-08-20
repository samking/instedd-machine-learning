class AddRemoteDbServiceToDatasets < ActiveRecord::Migration
  def self.up
    add_column(:datasets, :remote_db_service, :string)
  end

  def self.down
    remove_column(:datasets, :remote_db_service)
  end

end
