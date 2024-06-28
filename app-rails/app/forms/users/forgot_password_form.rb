class Users::ForgotPasswordForm
  include ActiveModel::Model

  attr_accessor :email, :hp_field

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  validates :hp_field, absence: true
end
