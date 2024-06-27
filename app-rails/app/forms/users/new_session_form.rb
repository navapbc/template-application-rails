# frozen_string_literal: true

class Users::NewSessionForm
  include ActiveModel::Model

  attr_accessor :email, :password

  validates :email, :password, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP, multiline: true }, if: -> { email.present? }
end
