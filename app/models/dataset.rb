class Dataset < ActiveRecord::Base
	@@sdb = Aws::SdbInterface.new( 'AKIAJTBXHDD2FWE4LYGQ', '9AmTRYMSoC66d660ixPLgioxCIlDIVPLlTN2USEs')
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

