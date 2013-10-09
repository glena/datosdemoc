json.array!(@data_collections) do |data_collection|
  json.extract! data_collection, 
  json.url data_collection_url(data_collection, format: :json)
end
