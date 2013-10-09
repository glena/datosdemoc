#encoding: utf-8
class ImportadorController < ApplicationController

  before_action :set_data_collection

  before_action :login_required

  def form

    params[:page_title] = 'Importar datos - Datos Democráticos'

  end

  def importar
    params[:page_title] = 'Importar datos - Datos Democráticos'

    uploaded_file = params[:csv]
    ImportadorCSV.importar uploaded_file.path, params[:importacion][:separador], @data_collection

    flash[:notice] = "Dataset importado satisfactoriamente."
    redirect_to data_collections_path

  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_data_collection
    @data_collection = DataCollection.find(params[:id])
  end

end