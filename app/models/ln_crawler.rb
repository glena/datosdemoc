#encoding: utf-8
class LNCrawler

  require 'hpricot'
  require 'open-uri'

  def self.get_pais
    Country.where(:name => 'Argentina').first
  end

  def self.get_provincia
    nil
  end

  def self.get_city
    nil
  end

  def self.createFields data_collection, fields

    type = DataType.get_string

    fields.each do |name|

      field = DataField.new
      field.data_collection = data_collection
      field.name = name
      field.data_type = type
      field.is_filter = false
      field.save
    end

  end

  def self.crawl
    puts "Inicio...\n"

    #url = URI.parse('http://data.lanacion.com.ar/dashboards/5068/inflacion-y-precios/')
    #doc = Hpricot open(url)

    puts "HTML loaded\n"

    self.importar_inflacion
    self.importar_inflacion_real

    puts "FIN"
  end

  def self.importar_inflacion_real

    puts "inflacion real"

    data_collection = DataCollection.where(:collection_name => "Inflación extraoficial mensual - inflacionverdadera.com").first

    if data_collection.nil?

      data_collection = DataCollection.new
      data_collection.name = "Inflación extraoficial mensual - inflacionverdadera.com"
      data_collection.description = "Variación intermensual de precios. Fuente: http://www.inflacionverdadera.com/"
      data_collection.institution = "InflacionVerdadera.com"
      data_collection.collection_name =  "inflacion_mensual_inflacionverdadera_com"
      data_collection.country = self.get_pais
      data_collection.province = self.get_provincia
      data_collection.city = self.get_city
      if data_collection.save

        category = Category.where(:name => 'Actividad Económica').first
        col_cat = DataCollectionCategory.new
        col_cat.data_collection = data_collection
        col_cat.category = category
        col_cat.save

        puts "\t\tImportando CSV...\t"

      else
        puts "\n\n\t\tERROR ON SAVE #{name} - #{title}\n\n"
      end
    end

    begin
      ImportadorCSV.importar "http://www.inflacionverdadera.com/download/inflacion-indices.xls", "\t", data_collection
      puts "\t\tImportacion finalizada\t"
    rescue
      data_collection.destroy
      puts "\t\tERROR -> ROLLBACK\t"
    end

  end
  def self.importar_inflacion

    puts "Inicio inflacion...\n"

    url = URI.parse('https://docs.google.com/spreadsheet/pub?key=0AuNh4LTzbqXMdGFYVDA0ZWg4ZTlkRkhCaFdtUnotdGc')
    doc = Hpricot open(url, {ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE})

    puts "HTML loaded\n"

    @colections = {}

    self.create_collection 'INDEC', {
      :name=>"Inflación oficial mensual - Indec",
      :description=>"Variación intermensual de precios.",
      :institution=>"Indec",
      :collection_name=>"inflacion_mensual_indec",
      :country=>self.get_pais,
      :province=>self.get_provincia,
      :city=>self.get_city
    }, ["FECHA", "VARIACION"]

    self.create_collection 'IPC CONGRESO', {
        :name=>"Inflación oficial mensual - IPC - Congreso de la Nación",
        :description=>"Variación intermensual de precios.",
        :institution=>"Congreso de la Nación",
        :collection_name=>"inflacion_mensual_congreso",
        :country=>self.get_pais,
        :province=>self.get_provincia,
        :city=>self.get_city
    }, ["FECHA", "VARIACION"]


    ignore = true

    doc.search("#content tr").each do |row|


      if row[:dir] == 'ltr'

        if not ignore

          variacion = row.search("td[5]").first
          fecha = row.search("td[6]").first

          if not (variacion.empty? || fecha.empty?)
            hash = {
              'FECHA'=>fecha.inner_html.strip,
              'VARIACION'=>variacion.inner_html.strip.to_f
            }

            institucion = row.search("td[3]").first.inner_html.strip

            @colections[institucion].add hash
          end
        end

        ignore = false
      end

    end

    @colections.values.each do |col|
      col.insert
    end

  end

  def self.create_collection col_key, data, fields


    col = DataCollection.where(:collection_name => data[:collection_name]).first

    if col.nil?
      col = DataCollection.new
      col.name = data[:name]
      col.description = data[:description]
      col.institution = data[:institution]
      col.collection_name =  data[:collection_name]
      col.country = data[:country]
      col.province = data[:province]
      col.city = data[:city]
      col.save

      category = Category.where(:name => 'Actividad Económica').first
      col_cat = DataCollectionCategory.new
      col_cat.data_collection = col
      col_cat.category = category
      col_cat.save

      self.createFields col, fields
    end

    inserter = MongoDataInserter.new col.collection_name
    inserter.clear
    @colections[col_key] = inserter
  end

end