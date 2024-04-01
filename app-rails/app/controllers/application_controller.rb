# Not to be confused with a "benefits application" or "claim".
# This is the parent class for all other controllers in the application.
class ApplicationController < ActionController::Base
  around_action :switch_locale

  # Set the active locale based on the URL
  # For example, if the URL starts with /es-US, the locale will be set to :es-US
  def switch_locale(&action)
    locale = params[:locale] || I18n.default_locale
    I18n.with_locale(locale, &action)
  end
end
