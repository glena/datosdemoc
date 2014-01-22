#encoding: utf-8
class HomicidiosDolososCrawler

  def self.run
    data_i = 'http://www.csjn.gov.ar/investigaciones/2012/caba/data/indexI.xml'
    data_v = 'http://www.csjn.gov.ar/investigaciones/2012/caba/data/indexV.xml'

    require 'open-uri'

    puts "Inicio...\n"

    dc = DataCollection.new
    dc.name = "Homicidios Dolosos en CABA 2012"
    dc.description = "Homicidios Dolosos 2012 CABA extraidos del gráfico http://www.csjn.gov.ar/investigaciones/2012/caba/caba2012.html de la Corte Suprema de Justicia de la Nación"
    dc.institution = "Corte Suprema de Justicia de la Nación"
    dc.country_id = 1
    dc.province_id = 2
    dc.collection_name = "homicidios_dolosos_caba_2012"
    dc.save

    fields = {}
    self.create_field fields, dc, "estado", false
    self.create_field fields, dc, "victimavictimario", false
    self.create_field fields, dc, "movil", false
    self.create_field fields, dc, "sexo", false
    self.create_field fields, dc, "edad", false
    self.create_field fields, dc, "nacionalidad", false
    self.create_field fields, dc, "arma", false
    self.create_field fields, dc, "horario", false
    self.create_field fields, dc, "comuna", false
    self.create_field fields, dc, "barrio", false
    self.create_field fields, dc, "villa", false
    self.create_field fields, dc, "numero", false
    self.create_field fields, dc, "ejex", false
    self.create_field fields, dc, "ejey", false
    self.create_field fields, dc, "cantidad", false
    self.create_field fields, dc, "id", false
    self.create_field fields, dc, "lugar", false
    self.create_field fields, dc, "hora", false
    self.create_field fields, dc, "fecha", false

    inserter = MongoDataInserter.new(dc.collection_name)
    inserter.clear

    puts "Loading I"
    self.load data_i, fields, inserter

    puts "Loading V"
    self.load data_v, fields, inserter

    inserter.insert
  end

  def self.create_field fields, dc, name, is_filter
    df = DataField.new
    df.name = name
    df.is_filter = is_filter
    df.data_collection = dc
    df.data_type_id = 3
    df.save

    fields[name] = df
  end

  def self.load url, fields, inserter
    data_url = 'http://www.csjn.gov.ar/investigaciones/2012/caba/data/'

    xml = open(URI.parse(url)).read()

    Hash.from_xml(xml)["mcs"]["mc"].each do |item|
      puts "loading item #{item}"
      puts "#{data_url}#{item}.txt"

      raw = open(URI.parse("#{data_url}#{item}.txt")).read()
      data = CGI::parse raw

      data.keys.each do |key|

        data[key] = data[key].first

      end

      inserter.add data
    end


  end

end