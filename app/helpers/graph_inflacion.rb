class GraphInflacion

  def get_template
    return '_comparativa_inflacion'
  end

  def get_name
    return 'comparativa inflacion'
  end

  def parse_date str
    str
  end

  def get_data
    graph_data = {}

    mongo_collection = MongoConnection.instance.get_collection 'inflacion_mensual_indec'
    data = mongo_collection.find({ 'FECHA'=>{ '$gt'=>'2010-01-01' } })

    data.each do |item|
       row = ['',0,0,0,0]
       fecha = self.parse_date item['FECHA']
       if graph_data.has_key? fecha
          row = graph_data[fecha]
       end

       row[0] = fecha
       row[1] = item['VARIACION'].to_f

       graph_data[fecha] = row
    end

    mongo_collection = MongoConnection.instance.get_collection 'inflacion_mensual_congreso'
    data = mongo_collection.find({ 'FECHA'=>{ '$gt'=>'2010-01-01' } })

    data.each do |item|
      row = [0,0,0,0]
      fecha = self.parse_date item['FECHA']
      if graph_data.has_key? fecha
        row = graph_data[fecha]
      end

      row[0] = fecha
      row[2] = item['VARIACION'].to_f

      graph_data[fecha] = row
    end


    mongo_collection = MongoConnection.instance.get_collection 'inflacion_mensual_inflacionverdadera_com'
    data = mongo_collection.find({ 'fecha'=>{ '$gt'=>'2010-01-01' } })

    data.each do |item|
      row = [0,0,0,0]
      fecha = self.parse_date item['fecha']
      if graph_data.has_key? fecha
        row = graph_data[fecha]
      end

      row[0] = fecha
      row[3] = item['indicealimentosybebidas'].to_f
      row[4] = item['indicecanastabasica'].to_f

      graph_data[fecha] = row
    end

    graph_data.values.sort_by{|e| e[0]}
  end

end