# frozen_string_literal: true

# Not to be confused with a "benefits application" or "claim".
# This is the parent class for all other controllers in the application.
class ApplicationController < ActionController::Base
  include Pundit::Authorization

  around_action :switch_locale
  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index

  # Set the active locale based on the URL
  # For example, if the URL starts with /es-US, the locale will be set to :es-US
  def switch_locale(&action)
    locale = params[:locale] || I18n.default_locale
    I18n.with_locale(locale, &action)
  end

  # After a user signs in, Devise uses this method to determine where to route them
  def after_sign_in_path_for(resource)
    unless resource.is_a?(User)
      raise "Unexpected resource type"
    end

    if resource.mfa_preference.nil?
      return users_mfa_preference_path
    end

    users_account_path
  end

  # Intercept redirect_to to replace the host with APP_HOST (the public hostname).
  def redirect_to(options = {}, response_options_and_flash = {})
    app_host = ENV["APP_HOST"]
    if app_host.present?
      options = case options
      when String
        if options.start_with?("http://", "https://")
          options.sub(%r{\Ahttps?://[^/]+}, "https://#{app_host}")
        elsif options.start_with?("/")
          "https://#{app_host}#{options}"
        else
          options
        end
      when Hash
        { host: app_host, protocol: "https" }.merge(options)
      else
        options
      end
      response_options_and_flash = response_options_and_flash.merge(allow_other_host: true)
    end
    super
  end

  private

  # Compare the Origin header against the configured APP_HOST (the public hostname) instead.
  def valid_request_origin?
    app_host = ENV["APP_HOST"]
    if app_host.present?
      request.origin.nil? || request.origin == "#{request.scheme}://#{app_host}"
    else
      super
    end
  end

end
