# frozen_string_literal: true

class Users::RegistrationForm
  include ActiveModel::Model

  attr_accessor :email, :password, :password_confirmation, :role

  validates :email, :password, :role, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, if: -> { email.present? }

  validates :password, confirmation: true, if: -> { password.present? }
end
