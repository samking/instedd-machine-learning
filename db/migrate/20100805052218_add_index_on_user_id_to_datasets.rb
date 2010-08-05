class AddIndexOnUserIdToDatasets < ActiveRecord::Migration
  def self.up
    add_index :datasets, :user_id
  end

  def self.down
    remove_index :datasets, :user_id
  end
end
