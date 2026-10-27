class SubscribersController < ApplicationController
  def create
    unless params[:consent] == "1"
      redirect_to teaser_path, alert: "Нужно согласие на обработку персональных данных."
      return
    end

    subscriber = Subscriber.new(email: params[:email])
    if subscriber.save
      NewsletterMailer.welcome_email(subscriber.email).deliver_later
      redirect_to teaser_path, notice: "Спасибо. Мы записали почту и свяжемся, когда будет первый разбор."
    else
      redirect_to teaser_path, alert: subscriber.errors.full_messages.to_sentence
    end
  end
end
