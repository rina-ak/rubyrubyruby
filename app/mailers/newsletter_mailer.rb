class NewsletterMailer < ApplicationMailer
  def welcome_email(email)
    @email = email
    mail(to: email, subject: "Добро пожаловать в decode — контекст за пределами звука")
  end
end
