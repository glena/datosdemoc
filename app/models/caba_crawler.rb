class CABACrawler

  #es un asco, rehacer

  def self.get_pais
    Country.where(:name => 'Argentina').first
  end

  def self.get_provincia
    Province.where(:name=> "Ciudad Autonoma de Buenos Aires").first
  end

  def self.get_city
    nil
  end

  def self.get_institution
    'Buenos Aires Ciudad'
  end

  def self.crawl

    require 'hpricot'
    require 'open-uri'

    puts "Inicio...\n"

    url = URI.parse('http://data.buenosaires.gob.ar/dataset')
    doc = Hpricot open(url)

    puts "HTML loaded\n"

    doc.search("h3.dataset-heading>a").each do |link|
      title   = link.inner_html.strip
      href   = link[:href]
      url = "http://data.buenosaires.gob.ar#{href}"
      puts "\nProcesando #{title} \n\t #{url}\n"

      self.load_dataset_page url
    end
  end

  def self.load_dataset_page page_url
    url = URI.parse(page_url)

    doc = Hpricot open(url)

    puts "\tPage loaded\n"

    name = doc.search("h1.dataset-header>a").inner_html.strip
    description = doc.search(".notes.embedded-content>p").inner_html.strip

    doc.search(".resource-list .resource-item").each do |link|
      format = link.search('span.format-label').inner_html

      if format == 'CSV'
        title   = link.search('a.heading').inner_html.split('<').first
        csv_url   = link.search('a.btn-resource').first[:href]
        csv_url   = csv_url.strip.sub('https', 'http')
        csv_url   = csv_url.chomp

        puts "\n\t\tNombre: #{name}\n";
        puts "\t\tTitle: #{title}\n";
        puts "\t\t#{csv_url}\n";

        data = DataCollection.where(:name => "#{name} - #{title}").first
        if data.nil?

          data_collection = DataCollection.new
          data_collection.name = "#{name} - #{title}"
          data_collection.description = description
          data_collection.institution = self.get_institution
          data_collection.collection_name =  self.get_collection_name "#{name} - #{title}"
          data_collection.country = self.get_pais
          data_collection.province = self.get_provincia
          data_collection.city = self.get_city
          if data_collection.save
            puts "\t\tImportando CSV...\t"

            begin
              ImportadorCSV.importar csv_url, nil, MongoDataInserter.new(data_collection)
              puts "\t\tImportacion finalizada\t"
            rescue
              data_collection.destroy
              puts "\t\tERROR -> ROLLBACK\t"
            end
          else
            puts "\n\n\t\tERROR ON SAVE #{name} - #{title}\n\n"
          end
        else
          puts "\n\n\t\tALREADY EXISTS #{name} - #{title}\n\n"
        end
      else
        puts "\t\t Formato #{format} ignorado"
      end

    end
  end


  def self.get_collection_name dataset_name

    name = dataset_name.gsub(/-/, ' ')
    name = name.squish
    name = name.gsub(/ /, '_')
    name = name.downcase

    name

  end
end
