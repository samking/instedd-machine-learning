#xml.instruct!
xml.dataset {
  xml.name(@dataset.name)
  xml.remote_db_service(@dataset.remote_db_service)
  xml.tag!("table_uuid", @dataset.table_uuid)
  xml.tag!("created_at", @dataset.created_at, "type" => "datetime")
  xml.id(@dataset.id, "type"=>"integer")
  xml.tag!("updated_at", @dataset.updated_at, "type" => "datetime")
  xml.data {
    @dataset.database_table.as_map.each do |row_name, row|
      if @dataset.database_table.is_tabular?
        xml.row("uuid" => row_name) {
          row.each do |col_header, col_data|
            xml.col(col_data, "header" => col_header)
          end
        }
      else
        xml.row(row, "uuid" => row_name)
      end
    end
  }
}

