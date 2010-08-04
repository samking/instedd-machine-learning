class ChangeClientUuidToTableUuid < ActiveRecord::Migration
  def self.up
    rename_column(:datasets, :client_uuid, :table_uuid)
  end

  def self.down
    rename_column(:datasets, :table_uuid, :client_uuid)
  end
end
