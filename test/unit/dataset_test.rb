require 'test_helper'
require 'blueprints'

class DatasetTest < ActiveSupport::TestCase

	def setup
		@dataset = Dataset.make_unsaved
	end

	test "should accept a normal account not in db" do
		if not @dataset.save 
			fail "failed to save dataset: #{@dataset.errors.full_messages}"
		end
		@dataset.destroy
	end

	test "should appear in db after posted" do
		@dataset.save
		assert Dataset.sdb.list_domains[:domains].include? @dataset.uid
		@dataset.destroy
	end

	test "should delete account in db" do
		@dataset.save
		assert @dataset.destroy
	end

	test "should create entry in simpledb" do
		Dataset.sdb.expects(:create_domain).with(@dataset.uid)
		@dataset.save
	end

	test "should not accept if uid is not unique" do
		Dataset.make :non_unique_uid
		dataset = Dataset.make_unsaved :non_unique_uid
		assert_false dataset.save
		dataset.destroy
	end

	#amazon won't accept 2 letter ids for domains
	test "should not accept if uid is <= 2 letters"  do 
		dataset = Dataset.make_unsaved :uid_short
		assert_false dataset.save
	end

end


