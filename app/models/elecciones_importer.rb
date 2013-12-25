#encoding: utf-8
class EleccionesImporter
  #es un asco, rehacer

  def self.get_pais

  end

  def self.get_provincia
    nil
  end

  def self.get_city
    nil
  end

  def self.create_data
    col = DataCollection.where(:collection_name => 'Elecciones legislativas 2013').first

    if col.nil?
      col = DataCollection.new
      col.name = 'Elecciones legislativas 2013'
      col.description = 'Resultados de las Elecciones Nacionales Legislativas de 27 de octubre de 2013'
      col.institution = 'Dirección Nacional Electoral - Minint'
      col.collection_name =  'elecciones_nacionales_legislativas_20131027'
      col.country = Country.where(:name => 'Argentina').first
      col.province = nil
      col.city = nil
      col.save

      category = Category.where(:name => 'Administración pública y normativa').first
      col_cat = DataCollectionCategory.new
      col_cat.data_collection = col
      col_cat.category = category
      col_cat.save

      self.createFields col, [:distrito,
                              :seccion,
                              :circuito,
                              :mesa,
                              :estado,
                              :voto,
                              :senadores_nacionales,
                              :diputados_nacionales,
                              :diputados_provinciales]
    end

    @inserter = MongoDataInserter.new col.collection_name
    @inserter.clear
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

    require 'hpricot'
    require 'open-uri'

    puts "Inicio...\n"

    self.create_data

    url = URI.parse('http://www.resultados.gob.ar/telegramas/IPRO.htm')
    doc = Hpricot open(url)

    puts "HTML loaded\n"

    doc.search("div.ulmes ul li a").each do |link|
      title   = link.inner_html.strip
      href   = link[:href]

      puts "\tProcessing Municipio #{title} - #{href} \n"

      self.load_municipio href
    end

  end


  def self.load_municipio file

    puts file

    url = URI.parse("http://www.resultados.gob.ar/telegramas/#{file}")
    doc = Hpricot open(url)

    puts "\t\tHTML loaded\n"

    doc.search("div.ulmes ul li a").each do |link|
      title   = link.inner_html.strip
      href   = link[:href]

      puts "\t\tProcessing Circuito #{title} - #{href} \n"

      self.load_circuito href
    end

  end


  def self.load_circuito file

    puts file

    url = URI.parse("http://www.resultados.gob.ar/telegramas/#{file}")
    doc = Hpricot open(url)

    puts "\t\t\tHTML loaded\n"

    doc.search("div.ulmes ul li a").each do |link|
      title   = link.inner_html.strip
      href   = link[:href]

      puts "\t\t\tProcessing Mesa #{title} - #{href} \n"

      self.load_mesa href
    end

  end


  def self.load_mesa file

    puts file

    url = URI.parse("http://www.resultados.gob.ar/telegramas/#{file}")
    doc = Hpricot open(url)

    puts "\t\t\tHTML loaded\n"

    doc.search("div.ulmes ul li a").each do |link|
      title   = link.inner_html.strip
      href   = link[:href]

      puts "\t\t\tProcessing Mesa #{title} - #{href} \n"

      self.load_data href
    end

  end


  def self.load_data file

    puts file

    url = URI.parse("http://www.resultados.gob.ar/telegramas/#{file}")
    doc = Hpricot open(url,"r:utf-8:utf-8")

    puts "\t\t\tHTML loaded\n"

    caja_pdf = doc.search("#caja_pdf")

    return if caja_pdf[0].nil?

    scan_path = caja_pdf[0][:src]

    telegrama_scan = "http://www.resultados.gob.ar/telegramas/#{scan_path}"

    datos_telegrama = doc.search('//*[@id="contentinfomesa"]/div[@class="altreinta"]/table/tbody/tr/td')

    distrito =  datos_telegrama[0].inner_html.strip
    seccion =   datos_telegrama[1].inner_html.strip
    circuito =  datos_telegrama[2].inner_html.strip
    mesa =      datos_telegrama[3].inner_html.strip
    estado =    datos_telegrama[4].inner_html.strip

    votos_impugnados = doc.search('//*[@id="contentinfomesa"]/div[@class="pt2"]/table/tbody/td')[0].inner_html.strip


    @inserter.add ({:distrito=>distrito,
                    :seccion=>seccion,
                    :circuito=>circuito,
                    :mesa=>mesa,
                    :estado=>estado,
      :voto=>'Impugnados',
      :senadores_nacionales=>votos_impugnados,
      :diputados_nacionales=>nil,
      :diputados_provinciales=>nil
    })


    doc.search('//*[@id="contentinfomesa"]/div[@class="pt1"]/table/tbody/tr').each do |row|

      cantidades = row.search('td')


      @inserter.add ({:distrito=>distrito,
                      :seccion=>seccion,
                      :circuito=>circuito,
                      :mesa=>mesa,
                      :estado=>estado,
        :voto=>row.search('th')[0].inner_html.strip,
        :senadores_nacionales=>self.fix_cantidad(cantidades[0].inner_html.strip),
        :diputados_nacionales=>self.fix_cantidad(cantidades[1].inner_html.strip),
        :diputados_provinciales=>self.fix_cantidad(cantidades[2].inner_html.strip)
      })

    end

    doc.search('//*[@id="TVOTOS"]/tbody/tr').each do |row|
      cantidades = row.search('td')


      @inserter.add ({:distrito=>distrito,
                      :seccion=>seccion,
                      :circuito=>circuito,
                      :mesa=>mesa,
                      :estado=>estado,
        :voto=>row.search('th')[0].inner_html.strip,
        :senadores_nacionales=>self.fix_cantidad(cantidades[0].inner_html.strip),
        :diputados_nacionales=>self.fix_cantidad(cantidades[1].inner_html.strip),
        :diputados_provinciales=>self.fix_cantidad(cantidades[2].inner_html.strip)
      })

    end

    @inserter.insert


  end

  def self.fix_cantidad cantidad
    return nil if cantidad == '&nbsp;'
    cantidad
  end

end