xml.instruct!
xml.urlset(
    'xmlns'.to_sym => "http://www.sitemaps.org/schemas/sitemap/0.9",
    'xmlns:image'.to_sym => "http://www.google.com/schemas/sitemap-image/1.1"
) do
  @static_pages.each do |page|
    xml.url do
      xml.loc "http://datosdemocraticos.com.ar#{page}"
      xml.changefreq("daily")
    end
  end

  @collections.each do |collection|
    xml.url do
      xml.loc "http://datosdemocraticos.com.ar#{api_call_path (collection.collection_name)}"
      xml.changefreq("daily")
    end

  end
end