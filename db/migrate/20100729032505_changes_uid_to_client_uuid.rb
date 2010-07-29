class ChangesUidToClientUuid < ActiveRecord::Migration
  def self.up
    rename_column(:datasets, :uid, :client_uuid)
  end

  def self.down
    rename_column(:datasets, :client_uuid, :uid)
  end
end
