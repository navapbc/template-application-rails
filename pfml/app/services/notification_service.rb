# frozen_string_literal: true

# Send notifications, sometimes with links to attachments.
class NotificationService
  def self.send_email_notification(mailer, mailer_args, mailer_action, recipients = [])
    Rails.logger.info({
      msg: "Send email notification",
      mailer: mailer.name,
      # @TODO: Beware PII and other sensitive data that should not be logged.
      mailer_args: mailer_args,
      mailer_action: mailer_action,
      recipients: recipients
    })

    # @TODO: Remove after the emails for user(s) have been added by callers
    recipients << "pfml-accelerator-testing@navapbc.com"

    recipients.each do |recipient|
      mailer_args[:email_address] = recipient
      mail_message = mailer
        .with(mailer_args)
        .send(mailer_action)

      # @TODO: Beware PII and other sensitive data that should not be logged.
      Rails.logger.debug({
        msg: "Generated mail message",
        mail_message: mail_message
      })

      mail_message.deliver_now
    end
  end
end
