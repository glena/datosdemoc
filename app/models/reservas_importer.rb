class ReservasImporter

  def self.run

    require 'hpricot'
    require 'open-uri'


    url = URI.parse('http://www.bcra.gov.ar/estadis/es010100.asp?descri=1&fecha=Fecha_Serie&campo=Res_Int_BCRA')
    doc = Hpricot open(url)

    selects = doc.search("select")

    desde = selects.first.search('option')[1][:value]
    hasta = selects[1].search('option')[1][:value]

    params = {

        'desde' => desde,
        'hasta' => hasta,
        'I1.x' => 23,
        'I1.y' => 10,
        'I1' => 'Enviar',
        'fecha' => 'Fecha_Serie',
        'descri' => 1,
        'campo' => 'Res_Int_BCRA'

    }

    mongo_collection = MongoConnection.instance.get_collection 'reservas_internacionales_bcra'

    request = RestClient.post  "http://www.bcra.gov.ar/estadis/es010100.asp", params
    datos = Hpricot request
    ignore = true
    datos.search('table tr').each do |row|

      if ignore
        ignore = false
      else
        celdas = row.search("td")
        fecha = celdas.first.inner_html
        monto = celdas.last.inner_html.to_i

        mongo_collection.update(
            {'fecha'=>fecha},
            {
                "$set" => {
                  'monto' => monto
                },
                "$setOnInsert" => {
                  'informacion' => ''
                }
            },
            { upsert: true }
        )



      end

    end




  end

end