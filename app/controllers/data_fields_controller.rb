#encoding: utf-8
class DataFieldsController < ApplicationController
  before_action :set_data_field , only: [:show, :edit, :update, :destroy]
  before_action :set_menu_item

  before_action :login_required


  # GET /data_fields
  # GET /data_fields.json
  def index
    @data_collection = DataCollection.find params[:data_collection_id]
    @data_fields = DataField.where(:data_collection => @data_collection)
  end

  # GET /data_fields/1
  # GET /data_fields/1.json
  def show
  end

  # GET /data_fields/new
  def new
    @data_collection = DataCollection.find params[:data_collection_id]
    @data_field = DataField.new
  end

  # GET /data_fields/1/edit
  def edit
    @data_collection = @data_field.data_collection
  end

  # POST /data_fields
  # POST /data_fields.json
  def create
    @data_field = DataField.new(data_field_params)
    @data_field.data_collection_id = params[:data_collection_id]

    respond_to do |format|
      if @data_field.save
        format.html { redirect_to data_collection_data_fields_path (@data_field.data_collection.id), notice: 'Data field was successfully created.' }
        format.json { render action: 'show', status: :created, location: @data_field }
      else
        format.html { render action: 'new' }
        format.json { render json: @data_field.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /data_fields/1
  # PATCH/PUT /data_fields/1.json
  def update
    respond_to do |format|
      if @data_field.update(data_field_params)
        format.html { redirect_to data_collection_data_fields_path (@data_field.data_collection.id), notice: 'Data field was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @data_field.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /data_fields/1
  # DELETE /data_fields/1.json
  def destroy
    @data_field.destroy
    respond_to do |format|
      format.html { redirect_to data_collection_data_fields_path(@data_field.data_collection.id) }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_data_field
        @data_field = DataField.find(params[:id])

        if @data_field.data_collection.id != params[:data_collection_id].to_i
          raise 'Error'
        end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def data_field_params
      allow = [:name,:is_filter,:data_type_id,:data_collection_id]
      params.require(:data_field).permit(allow)
    end

    def set_menu_item
      params[:current_menu_item] = :datos
    end
end
