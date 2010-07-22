require File.expand_path(File.join(File.dirname(__FILE__), "quoted_arg_constant"))

When /^the test client (doesn't|shouldn't) have a table in the remote database$/ do |group|
  assert_false Dataset.has_database_table? "test"
end

When /^the test client should have a table in the remote database$/ do
  assert Dataset.has_database_table? "test"
end

When /^the test client signs up for a table in the remote database using curl$/ do
  curl = Curl::Easy.new(url_for(:controller => 'datasets', :host => 'localhost:3000'))
  curl.follow_location = true #will redirect on success
  curl.http_post("dataset[uid]=test")
  $curl_response = curl.body_str
end

When /^the test client signs up for a table in the remote database using the web interface$/ do
  #Then "I go to #{url_for(:controller => 'datasets', :action => 'new', :host => 'localhost:3000') }"
  Then "I go to the new dataset page"
    And "I fill in \"dataset_uid\" with \"test\""
    And "I press \"dataset_submit\""
end

When /^the test client signs up for a table in the remote database$/ do
  #Then "the test client signs up for a table in the remote database using curl"
  Then "the test client signs up for a table in the remote database using the web interface"
end

When /^the test client successfully deletes the table in the remote database$/ do
  Then "the test client should have a table in the remote database"
    And "the test client deletes the table in the remote database using curl"
    And "the test client doesn't have a table in the remote database"
end

When /^the test client deletes the table in the remote database using curl$/ do
  curl = Curl::Easy.new(url_for(:host => 'localhost:3000', :controller => 'datasets', :action => 'test'))
  curl.follow_location = true #will redirect on success
  curl.http_delete
  $curl_response = curl.body_str
end

When /^the response to curl should include #{QUOTED_ARG}$/ do |desired_curl_response|
  assert_match desired_curl_response, $curl_response #TODO: uses global variable because different steps need to pass messages
end

When /^the test client deletes the table in the remote database using the web interface$/ do
  visit dataset_path 'test'
  Then "I follow \"Destroy\""
end

When /^the test client deletes the table in the remote database$/ do
  #Then "the test client deletes the table in the remote database using curl"
  Then "the test client deletes the table in the remote database using the web interface"
end

When /^the test client successfully signed up for a table in the remote database$/ do
  Then "the test client doesn't have a table in the remote database"
    But "the test client signs up for a table in the remote database"
    And "the test client should have a table in the remote database"
    And "I should see \"Dataset was successfully created\""
end

#test "should delete account in db" do
#  @dataset.save 
#  assert @dataset.destroy
#end
#
#test "should accept a normal account not in db" do
#  assert @dataset.save, "failed to save dataset: #{@dataset.errors.full_messages}"
#  @dataset.destroy
#end
#
#test "should appear in db after posted" do
#  @dataset.save
#  assert Dataset.sdb.list_domains[:domains].include? @dataset.uid
#  @dataset.destroy
#end

When /^we put a #{QUOTED_ARG} row #{QUOTED_ARG} column #{QUOTED_ARG} CSV file at #{QUOTED_ARG}$/ do |num_rows, num_cols, size, url|
  fail
end

When /^we adde?d? #{QUOTED_ARG} to the database$/ do |url|
  Curl::Easy.http_put(url_for(:action => 'update') + "/test", url).body_str
end

When /^the contents of the file at #{QUOTED_ARG} is in the database$/ do |url|
  fail
end

When /^we delete a #{QUOTED_ARG} column from a #{QUOTED_ARG} row$/ do |col_reality, row_reality|
  fail
end


