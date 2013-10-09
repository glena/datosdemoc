json.array!(@data_fields) do |data_field|
  json.extract! data_field, 
  json.url data_field_url(data_field, format: :json)
end
