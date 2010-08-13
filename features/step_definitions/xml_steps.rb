#properties_to_get: an array of strings/symbols
#returns: a hash from each (symbolized) property passed in to the value stored in the text field of that xml node
#Assumes that the xml document contains each of the passed in properties
def get_xml_properties(xml_document, properties_to_get) 
  xml_parser = REXML::Document.new xml_document
  xml_properties = {}
  properties_to_get.each do |property_to_get|
    property_to_get = property_to_get.to_s
    property_node = xml_parser.root.detect {|node| node.kind_of? REXML::Element and node.name == property_to_get}
    property_to_get.gsub!(/-/, "_")
    xml_properties[property_to_get.to_sym] = property_node.text
  end
  return xml_properties
end

