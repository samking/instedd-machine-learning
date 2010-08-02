require File.expand_path(File.join(File.dirname(__FILE__), "quoted_arg_constant"))

def get_url_file_descriptor(filename)
  url = "#{$TEST_HOST}/tests/#{filename}"
  return open(url)
end


#Not completely random if each row doesn't have the same number of columns
#Also, repeated elements are fine
def get_random_csv_element(file_descriptor, num_elements=1)
  reader = CSV::Reader.create(file_descriptor)
  reader.shift
  rows = []
  reader.each {|row| rows << row}
  elems = num_elements.times.map do
    begin
      row = rows[rand(rows.length)]
      elem = row[rand(row.length)]
    end while elem.blank?
    elem
  end
  elems
end

def get_all_csv_elements(file_descriptor)
  reader = CSV::Reader.create(file_descriptor)
  reader.shift
  elems = []
  reader.each {|row| row.each {|col| elems << col unless col.nil? }}
  elems
end

When /^the contents of the #{QUOTED_ARG} csv file is in the database$/ do |filename|
  elements = get_all_csv_elements(get_url_file_descriptor(filename))
  db = @test_client[:dataset].database_table
  assert(db.has_elements?(elements),
         "Some element(s) didn't make it into the database.  The missing 
         elements were: \n
         #{db.which_elements_missing?(elements).inspect}.  \n\n
         The database contents: \n
         #{db.as_map.inspect}")
end

When /^the test client views their database table using the api$/ do
  visit(dataset_path(@test_client[:id]) + ".xml")
end

When /^the contents of the #{QUOTED_ARG} csv file is displayed to the api$/ do |filename|
  elements = get_all_csv_elements(get_url_file_descriptor(filename))
  elements.each do |element|
    assert_match(element, CGI.unescapeHTML(response_body), 
                 "The response to the api didn't include all of the elements that we tried to put in the database.  The (first) missing element:\n
                 #{element}\n
                 The response to the api:\n
                 #{response_body}")
  end
end

