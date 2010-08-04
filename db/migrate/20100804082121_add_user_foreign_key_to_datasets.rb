class AddUserForeignKeyToDatasets < ActiveRecord::Migration
  def self.up
    add_column(:datasets, :user_id, :integer)
  end

  def self.down
    remove_column(:datasets, :user_id)
  end
end
