# frozen_string_literal: true

class Users::ResetPasswordForm
  include ActiveModel::Model

  attr_accessor :email, :password, :code

  validates :email, :password, :code, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, if: -> { email.present? }
  validates :code, length: { is: 6 }, if: -> { code.present? }
end
