class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_locale

protected

  def set_locale
    available = I18n.available_locales
    I18n.locale = http_accept_language.compatible_language_from(available)
  end

end
