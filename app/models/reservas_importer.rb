class ReservasImporter

  def self.run

    require 'hpricot'
    require 'open-uri'

    url = URI.parse('http://www.bcra.gov.ar/Estadisticas/estprv010001.asp?descri=1&fecha=Fecha_Serie&campo=Res_Int_BCRA')
    doc = Hpricot open(url)

    selects = doc.search("select")

    desde = selects.first.search('option')[1][:value]
    hasta = selects[1].search('option')[1][:value]

    params = {

        'desde' => desde,
        'hasta' => hasta,
        'I1.x' => 34,
        'I1.y' => 10,
        'I1' => 'Enviar',
        'fecha' => 'Fecha_Serie',
        'descri' => 1,
        'campo' => 'Res_Int_BCRA'

    }

    mongo_collection = MongoConnection.instance.get_collection 'reservas_internacionales_bcra'

    request = RestClient.post  "http://www.bcra.gov.ar/Estadisticas/estprv010001.asp", params
    datos = Hpricot request.body.force_encoding('ISO-8859-1').encode('UTF-8')
    ignore = true
    datos.search('table#texto_columna_2 tr').each do |row|

      if ignore
        ignore = false
      else
        celdas = row.search("td")
        fecha = celdas.first.inner_html
        monto = celdas.last.inner_html.to_i

        o_fecha = Date.strptime(fecha, "%d/%m/%Y")
        fecha = o_fecha.strftime("%Y-%m-%d")

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
