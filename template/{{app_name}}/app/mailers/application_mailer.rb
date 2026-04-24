# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  # Make sure templates in app/views/overrides are used if present
  @@mailer_overrides = ActionView::FileSystemResolver.new(Rails.root.join("app/views/overrides"))
  prepend_view_path @@mailer_overrides

  default from: ENV["AWS_SES_FROM_EMAIL"] || ENV["SES_EMAIL"]
  layout "mailer"
end
