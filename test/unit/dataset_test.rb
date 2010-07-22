require 'test_helper'
require 'blueprints'

class DatasetTest < ActiveSupport::TestCase

  def setup
    @dataset = Dataset.make_unsaved :uid_test
  end
  #TODO: Turn the tests here into real unit tests.  Ie, just the input and output expected.  Not behavior tests.  Assume that the external services do what they're supposed to.  This especially goes for higher level functions like add to database rather than add to sdb database.

  ############
  #ADDING DATA
  ############

  test "should add data to existing row" do
  end

  #########################
  #DATABASE CREATE / DELETE
  #########################
  
  test "should not accept if uid is not unique" do
    Dataset.sdb.expects(:create_domain).with(@dataset.uid)
    @dataset.save
    dataset_duplicate = Dataset.make_unsaved :uid_test
    assert_false dataset_duplicate.save
  end

  #amazon won't accept 2 letter ids for domains
  test "should not accept if uid is <= 2 letters"  do 
    dataset = Dataset.make_unsaved :uid_short
    assert_false dataset.save
  end

  test "should create entry in simpledb" do
    Dataset.sdb.expects(:create_domain).with(@dataset.uid)
    assert @dataset.save
  end

  def host_named_csv_at_url name, url
  end

end

