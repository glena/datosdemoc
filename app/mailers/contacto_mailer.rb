#encoding: utf-8
class ContactoMailer < ActionMailer::Base
  default from: "info@datosdemocraticos.com"

  def form_contacto(email, nombre, mensaje)
    @email = email
    @nombre = nombre
    @mensaje = mensaje

    mail(:to => 'german.lena@gmail.com', :subject => "Datos Democráticos - Contacto via web")
  end
end
