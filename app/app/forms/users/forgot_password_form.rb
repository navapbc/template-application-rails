class Users::ForgotPasswordForm
  include ActiveModel::Model

  attr_accessor :email

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
end
