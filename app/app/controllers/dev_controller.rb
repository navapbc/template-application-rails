class DevController < ApplicationController
  before_action :check_env

  # Frontend sandbox for testing purposes during local development
  def sandbox
  end

  # Trigger an email to the email param
  def send_email
    email = params[:email]

    if email.present?
      RequestForInformationMailer.with(email_address: email, name: "Anton Weis").task_opened.deliver_now
      flash[:notice] = "Email sent to #{email}"
    else
      flash[:error] = "No email provided"
    end
    redirect_to dev_sandbox_path
  end

  private

    def check_env
      unless Rails.env.development?
        redirect_to root_path
        nil
      end
    end
end
