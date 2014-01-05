#encoding: utf-8
class IndexController < ApplicationController

  def home
    params[:page_title] = 'Datos Democráticos'
    params[:page_description] = 'Base de datos de Open Data liberada principalmente por instituciones gubernamentales (Open Gov, Gobierno Abierto). Rest API para acceder a los datasets. Visualizaciones de datos.'
  end

  def quienessomos
    params[:page_title] = '¿Quiénes somos? - Datos Democráticos'
    params[:page_description] = 'Quienes somos los responsables del API Rest para el acceso a Open Data.'
    params[:current_menu_item] = :nosotros
  end

  def contacto
    params[:page_title] = 'Contacto - Datos Democráticos'
    params[:page_description] = 'Ponete en contacto con nosotros. Preguntas sobre Open Data y Open Gov.'
    params[:current_menu_item] = :nosotros
  end

  def contacto_send
    email = params[:email].strip
    nombre = params[:nombre].strip
    mensaje = params[:mensaje].strip

    if email.empty? || nombre.empty? || mensaje.empty?
      flash[:notice] = "Por favor complete todos los campos del formulario."
      redirect_to contacto_path
    end

    ContactoMailer.form_contacto(email, nombre, mensaje).deliver

    flash[:notice] = "El mensaje se envio satisfactoriamente. Te responderemos lo antes posible."
    redirect_to contacto_path
  end

  def open_data_info
    params[:page_title] = 'Información sobre Open Data y Open Gov - Datos Democráticos'
    params[:page_description] = '¿Qué es Open Data y Open Gov? ¿Por qué es importante Open Data y Open Gov? ¿Para qué sirve Open Data y Open Gov?'
    params[:current_menu_item] = :opendatainfo
  end

  def error404

    params[:page_title] = 'No se encuentra - Datos Democráticos'

  end

  def error500

    params[:page_title] = 'Error - Datos Democráticos'

  end

end