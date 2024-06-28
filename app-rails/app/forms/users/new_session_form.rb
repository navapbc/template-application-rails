# frozen_string_literal: true

class Users::NewSessionForm
  include ActiveModel::Model

  attr_accessor :email, :password, :hp_field

  validates :email, :password, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, if: -> { email.present? }

  validates :hp_field, absence: true
end
