class SitemapController < ApplicationController
  def index
    @static_pages = [home_path, api_info_path, quienes_somos_path, contacto_path, open_data_info_path, data_collections_path, '/blog']
    @collections = @data_collections = DataCollection.all

  
    respond_to do |format|
      format.xml
    end
  end
end