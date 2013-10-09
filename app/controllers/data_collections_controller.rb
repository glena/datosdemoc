#encoding: utf-8
class DataCollectionsController < ApplicationController
  before_action :set_menu_item
  before_action :check_if_admin
  before_action :set_data_collection, only: [:show, :edit, :update, :destroy]

  before_action :login_required, :except => ['index']

  # GET /data_collections
  # GET /data_collections.json
  def index
    params[:page_title] = 'Listado de datasets de Open Data - Datos Democráticos'
    params[:page_description] = 'Listado de datasets de Open Data. Datos abiertos de instituciones principalmente gubernamentales (Open Gov).'

    @page = (params.has_key?(:page) ? params[:page].to_i : 0)
    limit = 16

    @data_collections = DataCollection.all.limit(limit).offset(limit * @page)

    count = DataCollection.count

    @has_next_page = (limit * (@page + 1) < count)
  end

  # GET /data_collections/1
  # GET /data_collections/1.json
  def show
  end

  # GET /data_collections/new
  def new
    if params.has_key? :id
      @data_collection = DataCollection.find params[:id]
      @data_collection.id = nil
      @data_collection.data_fields = []
    else
      @data_collection = DataCollection.new
    end
  end

  def clone

    data_collection = DataCollection.find params[:id]
    new_data = data_collection.dup

    new_data.save

    redirect_to edit_data_collection_path(new_data)

  end

  # GET /data_collections/1/edit
  def edit
  end

  # POST /data_collections
  # POST /data_collections.json
  def create
    @data_collection = DataCollection.new(data_collection_params)

    respond_to do |format|
      if @data_collection.save
        format.html { redirect_to importador_csv_path (@data_collection.id), notice: 'Data collection was successfully created.' }
        format.json { render action: 'show', status: :created, location: @data_collection }
      else
        format.html { render action: 'new' }
        format.json { render json: @data_collection.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /data_collections/1
  # PATCH/PUT /data_collections/1.json
  def update
    respond_to do |format|
      if @data_collection.update(data_collection_params)
        format.html { redirect_to importador_csv_path (@data_collection.id), notice: 'Data collection was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @data_collection.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /data_collections/1
  # DELETE /data_collections/1.json
  def destroy

    DataField.destroy_all :data_collection_id => @data_collection.id

    if not @data_collection.collection_name.nil?
      mongo_collection = MongoConnection.instance.get_collection @data_collection.collection_name
      mongo_collection.drop
    end

    @data_collection.destroy

    respond_to do |format|
      format.html { redirect_to data_collections_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_data_collection
      @data_collection = DataCollection.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def data_collection_params
      allow = [:name,:description,:institution,:collection_name,:country_id,:province_id,:city_id]
      params.require(:data_collection).permit(allow)
    end

    def set_menu_item
      params[:current_menu_item] = :datos
    end

    def check_if_admin
      user = self.get_logged_user
      @is_admin = false
      if not user.nil?
        @is_admin = user.is_admin?
      end
    end
end
