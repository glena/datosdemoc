class InflacionRealDataInserter < MongoDataInserter

  def initialize collection_name
    super collection_name
  end

  #def add row
  #
  #  fecha = DateTime.strptime(row['fecha'].strip, '%d-%m-%Y').strftime('%Y-%m')
  #
  #  if @raw_data.has_key? fecha
  #    item = @raw_data[fecha]
  #  else
  #    item = {
  #        'fecha'=>fecha,
  #        'indicealimentosybebidas'=>[],
  #        'indicecanastabasica'=>[]
  #    }
  #  end
  #
  #  item['indicealimentosybebidas'].push row['indicealimentosybebidas']
  #  item['indicecanastabasica'].push row['indicecanastabasica']
  #
  #
  #  @raw_data[fecha] = item
  #
  #end

  def add row

    fecha = DateTime.strptime(row['fecha'].strip, '%d-%m-%Y').strftime('%Y-%m-%d')

    item = {
        'fecha'=>fecha,
        'indicealimentosybebidas'=>[],
        'indicecanastabasica'=>[]
    }

    super item

  end

  #def insert
  #  @data = @raw_data.values.map {|o|
  #
  #      o['indicealimentosybebidas'] = (o['indicealimentosybebidas'].reduce(:+).to_f / o['indicealimentosybebidas'].size)
  #      o['indicecanastabasica'] = (o['indicecanastabasica'].reduce(:+).to_f / o['indicecanastabasica'].size)
  #      o
  #
  #  }
  #
  #  @raw_data.clear
  #
  #  super
  #end

end