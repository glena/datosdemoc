#encoding: utf-8
class CEDOMCrawler
  #http://www.cedom.gov.ar/es/busca/proyect/busproy.php?buscanio=2013&autorcod=cualquier

  def self.get_pais
    Country.where(:name => 'Argentina').first
  end

  def self.get_provincia
    nil
  end

  def self.get_city
    nil
  end

  def self.get_institution
    'CEDOM'
  end

  def self.crawl

    last_imported = 0

    require 'hpricot'
    require 'open-uri'

    puts "Inicio...\n"

    target_path = 'http://www.cedom.gov.ar/es/busca/proyect/'
    target_page = 'busproy.php?buscanio=2013&autorcod=cualquier'


    data_collection = self.get_data_obj
    mongo_collection = MongoConnection.instance.get_collection data_collection.collection_name
    mongo_collection.drop

    url = URI.parse("#{target_path}#{target_page}")
    puts "HTML loaded\n"
    doc = Hpricot open(url)
    puts "\tPage loaded\n"

    data = []

    pages = doc.search("/html/body/div/a").map {|link|link[:href]}
    pages = pages.uniq

    doc.search("table tr").each do |row|
      links = row.search('td a')

      if (not links.nil?) && (not links.empty?)&& (links.count == 2)

        getinfo_doc = links.last[:href]
        proy_nro = links.first.inner_html

        if proy_nro.to_i >  last_imported

          puts "\tProcesando proyecto #{proy_nro}\n"

          hash = self.get_hash "#{target_path}#{getinfo_doc}"

          data.push hash

          if data.length == 1000
            mongo_collection.insert data
            data.clear

            puts "\t\tAlmacenando datos\n"
          end
        end
      end
    end

    pages.each do |page|
      #url = URI.parse("#{target_path}#{page}", :Cookie=>'cedombuscanio=2013; cedomautorcod=cualquier')
      conn = Net::HTTP.new('www.cedom.gov.ar', 80 )
      headers = { "Cookie" => 'cedombuscanio=2013; cedomautorcod=cualquier' }
      resp, resp_data = conn.get("#{target_path}#{page}", headers)

      puts "HTML loaded #{page}\n"
      #doc = Hpricot open(url)
      doc = Hpricot resp.body
      puts "\tPage loaded\n"

      doc.search("table tr").each do |row|
        links = row.search('td a')

        if (not links.nil?) && (not links.empty?)&& (links.count == 2)

          getinfo_doc = links.last[:href]
          proy_nro = links.first.inner_html

          if proy_nro.to_i >  last_imported
            puts "\tProcesando proyecto #{proy_nro}\n"

            hash = self.get_hash "#{target_path}#{getinfo_doc}"

            data.push hash

            if data.length == 1000
              mongo_collection.insert data
              data.clear

              puts "\t\tAlmacenando datos\n"
            end
          end
        end
      end

    end

    if data.length > 0
      mongo_collection.insert data
      data.clear
      puts "\t\tAlmacenando datos\n"
    end

    puts "\t\tfin\n"

  end

  def self.get_data_obj
    data_collection = DataCollection.where(:collection_name=>'proyectos_legislatura').first

    if data_collection.nil?

      data_collection = DataCollection.new
      data_collection.name = 'Proyectos de ley, legislatura'
      data_collection.description = 'Los proyectos de la Legislatura, son los comprendidos del año 1997 a la fecha. Los datos no poseen acentos, pero sí ñ.'
      data_collection.institution = self.get_institution
      data_collection.collection_name = 'proyectos_legislatura'
      data_collection.country = self.get_pais
      data_collection.province = self.get_provincia
      data_collection.city = self.get_city

      data_collection.save

      fields = [:nro_proyecto, :anio, :tipo, :resumen, :autores, :bloques, :tratamiento]
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

    data_collection
  end

  def self.get_hash parse_url
    data = {}
    puts "\t\tCargando hash\n"

    url = URI.parse(parse_url)

    puts "\t\tHTML loaded\n"

	again = true
	while again
		again = false
		begin
			io = open(url)
		rescue
			puts "ERROR TRY AGAIN"
			again = true
		end
	end
    
    doc = Hpricot io.read.encode('UTF-8', :invalid => :replace, :undef => :replace)

    link = doc.search('/html/body/table/tr[1]/td[2]/font/a').first

    download_url = link[:href].gsub('../', '').strip

    data[:nro_proyecto] = link.inner_html.gsub('&nbsp;', '').strip
    data[:data_download] = "http://www.cedom.gov.ar/#{download_url}"
    data[:anio] = doc.search('/html/body/table/tr[1]/td[5]/font').inner_html.gsub('&nbsp;', '').strip
    data[:tipo] = doc.search('/html/body/table/tr[2]/td[2]/font').inner_html.gsub('&nbsp;', '').strip
    data[:resumen] = doc.search('/html/body/table/tr[3]/td/div/font').inner_html.gsub('&nbsp;', '').gsub('<br />', '').gsub('<b>', '').gsub('</b>', '').strip
    data[:autores] = doc.search('/html/body/table/tr[4]/td[2]/font').inner_html.gsub('&nbsp;', '').strip
    data[:bloques] = doc.search('/html/body/table/tr[5]/td[2]/font').inner_html.gsub('&nbsp;', '').strip
    data[:tratamiento] = doc.search('/html/body/table/tr[6]/td[2]/font').inner_html.gsub('&nbsp;', '').strip

    data
  end
end