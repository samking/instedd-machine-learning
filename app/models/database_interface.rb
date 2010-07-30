#each instance is one 'table' in the database
class DatabaseInterface

  @@sdb = Aws::SdbInterface.new($user_config[:sdb_user], $user_config[:sdb_pass])
  def self.sdb
    @@sdb
  end

  def initialize(table_name)
    @table_name = table_name
  end

  SDB_MAX_NUM_CHUNKS = 256
  #the first 3 characters are the chunk identifier, and SDB can only 
  #take 1023 bytes per chunk
  SDB_CHUNK_IDENTIFIER_SIZE = 3
  SDB_MAX_CHUNK_SIZE = 1023 - SDB_CHUNK_IDENTIFIER_SIZE

  def self.has_table? table_name
    @@sdb.list_domains[:domains].include? table_name
  end

  def self.delete_table table_name
    @@sdb.delete_domain table_name
  end

  def self.create_table table_name
    @@sdb.create_domain table_name
  end

  def self.tables_list
    @@sdb.list_domains[:domains]
  end

  def remove_data(row_to_remove, col_to_remove=[])
    col_to_remove = [] if col_to_remove.blank? #empty parameter means delete the whole row
    @@sdb.delete_attributes(@table_name, row_to_remove, [col_to_remove])
  end

  #TODO: support formats other than csv
  #TODO: support csv without header (specify noheader by parameter)
  def add_data(data_url)
    reader = CSV::Reader.create(open(data_url))
    header = reader.shift

    items = []
    reader.each do |row| 
      #csv reader represents blank rows as [nil]
      next if (row.blank? or (row.length == 1 and row[0].nil?)) 

      attributes = {}
      header.zip(row) do |col_head, col|
        col = '' if col.nil?
        attributes[col_head] = chunk_sdb_attribute(col)
      end
      items << Aws::SdbInterface::Item.new(UUIDTools::UUID.random_create, attributes)
    end
    @@sdb.batch_put_attributes(@table_name, items)
  end

  #SDB only allows a limited number of 'attributes' per row.  One attribute 
  #means one value (where each column can have one or several values associated
  #with it).
  def num_attributes_remaining item_name
    num_attributes_used = @@sdb.get_attributes(@table_name, item_name)[:attributes].length
    return SDB_MAX_NUM_CHUNKS - num_attributes_used
  end

  #adds the learning_response to the provided row_names.  Assumes that each 
  #array is in the same order.
  def add_ml_response(row_names, learning_response, service)
    new_cols = []
    row_names.zip(learning_response) do |row_name, ml_response|
      new_cols << Aws::SdbInterface::Item.new(row_name, {"ml_#{service}:#{Time.new}" => 
                                              chunk_sdb_attribute(ml_response)})
    end
    @@sdb.batch_put_attributes(@table_name, new_cols)
  end

  def has_element? desired_element
    return has_elements [desired_element]
  end
  
  #Returns true if the database contains all of the desired_elements
  def has_elements? desired_elements 
    database_elements = as_set
    desired_elements.each do |desired_element|
      return false if not database_elements.include? desired_element
    end
    return true
  end

  #Returns the database as a list of two arrays: row_names and rows.
  #Each row is a map from column_name to column_data
  def as_array
    row_names = []
    rows = [] 
    @@sdb.select('select * from `' + @table_name + '`')[:items].each do |row| 
      row.each do |row_name, row_data| 
        row_names << row_name
        rows << reassemble_sdb_items(row_data)
      end
    end
    return row_names, rows
  end

  #Same as as_array, but doesn't include the row_name array
  def as_content_array
    as_array[1]
  end

  #Returns the database as a map from row_name to row.  Each row is a 
  #map from column_name to column_data.
  def as_map
    row_names, rows = as_array
    map = {}
    row_names.zip(rows) do |row_name, row|
      map[row_name] = row
    end
    map
  end

  #Returns the database as a set of the content.  Rows and columns are
  #forgotten.
  def as_set
    content = as_content_array
    set = Set.new
    content.each {|row| row.each {|column_name, column_data| set << column_data}}
    set
  end
    
  private

  #each attribute value stored in a SDB database can only be 
  #SDB_MAX_CHUNK_SIZE bytes However, each attribute can hold 
  #multiple values.  
  #This function splits one value into several associated with
  #one attribute.
  def chunk_sdb_attribute attribute
    return unless attribute
    total_length = attribute.length
    used_length = 0
    chunk_number = 1
    chunked_attribute = []
    remaining_attribute = attribute
    while used_length < total_length
      current_chunk = ("%0#{SDB_CHUNK_IDENTIFIER_SIZE}d" % chunk_number) + 
        remaining_attribute[0...SDB_MAX_CHUNK_SIZE]
      chunked_attribute << current_chunk
      remaining_attribute = remaining_attribute[SDB_MAX_CHUNK_SIZE..-1]
      used_length += current_chunk.length - SDB_CHUNK_IDENTIFIER_SIZE
      chunk_number += 1
    end
    chunked_attribute
  end

  def unchunk_sdb_attribute attribute_arr
    attr_map = {}
    attribute_arr.each do |chunk|
      index = chunk[0...SDB_CHUNK_IDENTIFIER_SIZE]
      chunk_payload = chunk[SDB_CHUNK_IDENTIFIER_SIZE..-1]
      attr_map[index] = chunk_payload
    end
    sorted_chunks = attr_map.sort.map {|key_val_arr| key_val_arr[1]}
    return sorted_chunks.join
  end

  def reassemble_sdb_items(items)
    reassembled_items = {}
    items.each do |col_head, val|
      reassembled_items[col_head] = unchunk_sdb_attribute(val)
    end
    reassembled_items
  end

  def self.hash_to_xml(hash, builder=Builder::XmlMarkup.new)
    builder.item {
      hash.each do |key, value|
        eval "builder.#{key}('#{value}')"
      end
    }
    builder.target!
  end

  def sdb_to_xml
    items = as_content_array
    builder = Builder::XmlMarkup.new
    items.each do |item|
      hash_to_xml(item, builder)  
    end
    builder.target!
  end

end
