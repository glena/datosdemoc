#encoding: utf-8
class ApiController < ApplicationController

  def call

    @data_collection = DataCollection.where(:collection_name => params[:collection]).first

    if @data_collection.nil?
      self.render_404
      return
    end

    status = 'ok'
    @message = ''
    @full = false
    @user = nil

    if params.has_key? :apikey
      @apikey = params[:apikey]
      @user = User.where(:apikey => @apikey).first
      if @user.nil?
        @message = 'El API Key no es válido, solo puede acceder al set de prueba limitado a 5 registros.'
        @apikey = nil
      else
        @message = 'Límite diario alcanzado, solo puede acceder al set de prueba limitado a 5 registros.'
      end
    else
      @user = self.get_logged_user
      @apikey = @user.apikey if not @user.nil?
    end

    if not @apikey.nil?
      if ApiUse.can_use @user

        pagesize = 100
        @page = 1
        @has_next_page = false

        if params.has_key? :page
          @page = params[:page].to_i
        end

        @full = true
      else
        @message = 'Límite diario alcanzado, solo puede acceder al set de prueba limitado a 5 registros.'
        @apikey = nil
      end
    else
      @message = 'Api key no proporcionada, solo puede acceder al set de prueba limitado a 5 registros.'
    end

    if @apikey.nil?
      status = 'warning'
      pagesize = 5
      @page = 1
      @has_next_page = false
    end

    params[:page_title] = "Dataset #{@data_collection.name} de #{@data_collection.institution} - Datos Democráticos"
    params[:page_description] = @data_collection.description

    mongo_collection = MongoConnection.instance.get_collection @data_collection.collection_name

    key_field = @data_collection.data_fields.where(:is_key => true).first
    if key_field

      sense = 1

      if params[:reverse]
        sense = -1
      end

      sort = {
          key_field.name => sense
      }
      @data = mongo_collection.find.sort( sort ).limit(pagesize).skip((@page-1) * pagesize)
    else
      @data = mongo_collection.find.limit(pagesize).skip((@page-1) * pagesize)
    end


    count = mongo_collection.count

    if (count > @page * pagesize) && (not @apikey.nil?)
      @has_next_page = true
    end

    respond_to do |format|
        format.html {
          
        }
        format.json { render json: { :estado => status, :mensaje => @message, :data => @data.as_json(except: ['_id']), :conteo_total => count, :tiene_otra_pagina => @has_next_page} }
    end
  end

  def edit
    @data_collection = DataCollection.where(:collection_name => params[:collection]).first
  end

  def update
    @data_collection = DataCollection.where(:collection_name => params[:collection]).first
    fields = @data_collection.data_fields
    key = @data_collection.data_fields.where(:is_key => true).first

    mongo_collection = MongoConnection.instance.get_collection @data_collection.collection_name

    values = {}
    fields.each do |field|
      values[field.name] = field.data_type.manager.format params[field.name]
    end

    if key
      key_name = key.name
      key_value = key.data_type.manager.format params[key_name]

      mongo_collection.update(
          {key_name=>key_value},
          values,
          { upsert: true }
      )
    else
      mongo_collection.insert values
    end





    redirect_to api_call_path (@data_collection.collection_name), notice: 'Los datos fueron actualizados.'
  end

  def info
    params[:page_title] = 'API Rest para acceder a Open Data - Datos Democráticos'
    params[:page_description] = 'Especificación del API para acceder a los data sets de Open Data.'
    params[:current_menu_item] = :datos
  end

  def viewer
    name = params[:name]
    @graph = GraphsFactory.instance.get name

    self.render_404 if @graph.nil?

    render @graph.get_template

  end

end