class Subscriber < ApplicationRecord
  before_validation :normalize_email

  validates :email,
    presence: { message: "укажите почту" },
    uniqueness: { case_sensitive: false, message: "уже подписан" },
    format: { with: URI::MailTo::EMAIL_REGEXP, message: "выглядит некорректно" }

  private

  def normalize_email
    self.email = email.to_s.strip.downcase
  end
end
