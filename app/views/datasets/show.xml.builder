#xml.instruct!
xml.dataset {
  xml.name(@dataset.name)
  xml.tag!("table-uuid", @dataset.table_uuid)
  xml.tag!("created-at", @dataset.created_at, "type" => "datetime")
  xml.id(@dataset.id, "type"=>"integer")
  xml.tag!("updated-at", @dataset.updated_at, "type" => "datetime")
  xml.data {
    @dataset.database_table.as_map.each do |row_name, row|
      xml.row("uuid" => row_name) {
        row.each do |col_header, col_data|
          xml.col(col_data, "header" => col_header)
        end
      }
    end
  }
}

