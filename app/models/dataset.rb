require 'csv'
require 'open-uri'

class Dataset < ActiveRecord::Base
	#TODO: support other database services
	@@sdb = Aws::SdbInterface.new($db_config[:sdb_user], $db_config[:sdb_pass])
	def self.sdb
		@@sdb
	end

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
	#TODO: support parameters to specify rows, cols, and services
	def learn_from_data(dataUrl)
		reader = CSV::Reader.create(open(dataUrl))
		header = reader.shift

		items = []
		reader.each do |row| 
			attributes = {}
			header.zip(row) do |col_head, col|
				attributes[col_head] = col
			end
			items << Aws::SdbInterface::Item.new(UUIDTools::UUID.timestamp_create, attributes)
		end
		@@sdb.batch_put_attributes(uid, items)
	end

	#TODO: ask machine learning services if we're still learning
	def is_learning?
		false
	end

	def get_items
		items = []
		@@sdb.select("select * from #{uid}")[:items].each do |item|
			item.each do |key, val|
				items << val
			end
		end
		items
	end

	def self.get_domain_list_string
		@@sdb.list_domains[:domains].inspect
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

