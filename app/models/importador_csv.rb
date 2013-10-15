class ImportadorCSV

  def self.get_separator content
    separador = nil

    if content.count(',') > content.count(';')
      separador = ','
    else
      separador = ';'
    end

    separador
  end

  def self.importar file_path, separador, data_collection

    require 'csv'

    mongo_collection = MongoConnection.instance.get_collection data_collection.collection_name

    mongo_collection.drop

    data = []

    first_row = true
    headers = []

    open(file_path,"r:utf-8:utf-8").each_line do |fline|

      if separador.nil?
        separador = self.get_separator fline
      end

      csv = fline.split separador

      if first_row
        headers = csv
        self.set_fields headers, data_collection
        first_row = false
      else
        hash = self.generar_hash headers, csv
        data.push hash

        if data.length == 1000
          mongo_collection.insert data
          data.clear
        end
      end

    end

    if data.length > 0
      mongo_collection.insert data
      data.clear
    end

  end

  def self.set_fields hash_keys, data_collection

    type = DataType.get_string

    hash_keys.each do |key|

      field = DataField.new
      field.data_collection = data_collection
      field.name = key
      field.data_type = type
      field.is_filter = false
      field.save

    end
  end

  def self.generar_hash headers, csv
    hash = {}
    (0..(headers.length-1)).each do |index|
      hash[headers[index]] = csv[index]
    end
    hash
  end


end