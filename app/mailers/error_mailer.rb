class ErrorMailer < ActionMailer::Base
  default from: "info@saisiner.com"

  def experror(e, url)
    @err=e
    @date = Time.current.to_s
    @current_url = url
    message = e.message[0, e.message.size > 35 ? 35 : e.message.size]
    mail(:to => 'german.lena@gmail.com', :subject => "[DATOS DEMOCRATICOS] - [ERROR] - #{@date} - #{message}...")
  end

end