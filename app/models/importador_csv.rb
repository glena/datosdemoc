class ImportadorCSV

  def self.importar file_path, separador, data_inserter, data_collection
    data = []
    first_row = true

    types = DataField.get_types_hash data_collection

    types = {}
    data_collection.fields.each do |field|
      types[field.name] = field.manager
    end

    SmarterCSV.process(file_path, {:col_sep => separador}) do |row|

      hash = row.first

      if first_row
        if types.empty?
          types = self.set_fields hash.keys, data_collection
        end
        first_row = false
      end

      data_inserter.add hash

    end

    data_inserter.insert
  end

  def self.set_fields hash_keys, data_collection

    type = DataType.get_string

    types_hash = {}

    hash_keys.each do |key|

      field = DataField.new
      field.data_collection = data_collection
      field.name = key.to_s
      field.data_type = type
      field.is_filter = false
      field.save

      types_hash[field.name] = DataType.get_manager(type)

    end

    types_hash
  end

end