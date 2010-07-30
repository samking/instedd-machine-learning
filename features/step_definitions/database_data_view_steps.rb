require File.expand_path(File.join(File.dirname(__FILE__), "quoted_arg_constant"))

#Not completely random if each row doesn't have the same number of columns
#Also, repeated elements are fine
def get_random_csv_element(file_descriptor, num_elements=1)
  reader = CSV::Reader.new(file_descriptor)
  reader.shift
  rows = reader.each.map
  elems = num_elements.times.map do
    begin
      row = rows[rand(rows.length)]
      elem = row[rand(row.length)]
    end while not elem.blank?
    elem
  end
  elems
end


#Tests if a random 10 elements in the file made it into the database
When /^the contents of the #{QUOTED_ARG} csv file is in the database$/ do |filename|
  url = "#{$TEST_HOST}/tests/#{filename}"
  elements = get_random_csv_element(open(url), 10)
  assert @test_client[:dataset].database_has_elements? elements, "Some element(s) didn't make it into the database.  The elemets were: #{elements}.  The database contents: #{@test_client[:dataset].get_database_as_map}"
end

When /^the test client views their database table using the api$/ do
  visit(dataset_path(@test_client[:id]))
end

