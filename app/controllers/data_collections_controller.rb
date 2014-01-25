#encoding: utf-8
class DataCollectionsController < ApplicationController
  before_action :set_menu_item
  before_action :check_if_admin
  before_action :validate_admin, only:[:edit, :new, :update, :destroy, :create, :clone]
  before_action :set_data_collection, only: [:show, :edit, :update, :destroy]

  before_action :login_required, :except => ['index']

  # GET /data_collections
  # GET /data_collections.json
  def index
    params[:page_title] = 'Listado de datasets de Open Data - Datos Democráticos'
    params[:page_description] = 'Listado de datasets de Open Data. Datos abiertos de instituciones principalmente gubernamentales (Open Gov).'

    @sel_category = params[:category]

    @page = (params.has_key?(:page) ? params[:page].to_i : 0)
    limit = 10

    @data_collections = DataCollection.all
    if not @sel_category.nil?
      @data_collections = @data_collections.joins('INNER JOIN data_collection_categories ON data_collection_categories.data_collection_id = data_collections.id').where('data_collection_categories.category_id = ?', @sel_category)
    end
    count = @data_collections.count

    @data_collections = @data_collections.limit(limit).offset(limit * @page)

    @total_pages = (count / limit).ceil
    @has_next_page = (limit * (@page + 1) < count)

    @categories = Category.all
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

    @categories = Category.all
    @selected_categories = []
  end

  def clone

    data_collection = DataCollection.find params[:id]
    new_data = data_collection.dup

    new_data.save

    redirect_to edit_data_collection_path(new_data)

  end

  # GET /data_collections/1/edit
  def edit
    @categories = Category.all
    @selected_categories = @data_collection.data_collection_categories.map {|c| c.category_id }
  end

  # POST /data_collections
  # POST /data_collections.json
  def create
    @data_collection = DataCollection.new
    @data_collection.name = params[:data_collection][:name]
    @data_collection.description = params[:data_collection][:description]
    @data_collection.institution = params[:data_collection][:institution]
    @data_collection.collection_name = params[:data_collection][:collection_name]
    @data_collection.country_id = params[:data_collection][:country_id]
    @data_collection.province_id = params[:data_collection][:province_id]
    @data_collection.city_id = params[:data_collection][:city_id]

    params[:categories].each do |category|

      collection_category = DataCollectionCategory.new
      collection_category.data_collection = @data_collection
      collection_category.category_id = category
      collection_category.save

    end

    respond_to do |format|
      if @data_collection.save
        format.html { redirect_to importador_csv_path (@data_collection.id), notice: 'Data collection was successfully created.' }
        format.json { render action: 'show', status: :created, location: @data_collection, params:data_collection_params }
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

      @data_collection.name = params[:data_collection][:name]
      @data_collection.description = params[:data_collection][:description]
      @data_collection.institution = params[:data_collection][:institution]
      @data_collection.collection_name = params[:data_collection][:collection_name]
      @data_collection.country_id = params[:data_collection][:country_id]
      @data_collection.province_id = params[:data_collection][:province_id]
      @data_collection.city_id = params[:data_collection][:city_id]

      if @data_collection.save

        @data_collection.data_collection_categories.map {|el| el.destroy}

        params[:categories].each do |category|

          collection_category = DataCollectionCategory.new
          collection_category.data_collection = @data_collection
          collection_category.category_id = category
          collection_category.save

        end

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

    def validate_admin
       if not @is_admin
         self.render_404
       end
    end
end
