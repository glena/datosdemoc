#encoding: utf-8

#http://guides.rubyonrails.org/action_mailer_basics.html

class UserMailer < ActionMailer::Base
  default from: "info@datosdemocraticos.com"

  def signup_confirmation (user)
    @user = user
    @host = ActionMailer::Base.default_url_options[:host]
    mail(:to => user.email, :subject => "Datos Democráticos - Activa tu cuenta")
  end

  def forgot_password_confirmation (user)
    @user = user
    @host = ActionMailer::Base.default_url_options[:host]
    mail(:to => user.email, :subject => "Datos Democráticos - Recuperación de password")
  end
end
