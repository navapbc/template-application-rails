class ApplicationMailer < ActionMailer::Base
  default from: ENV["AWS_SES_EMAIL"]
  layout "mailer"
end
