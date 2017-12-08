class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :set_locale
  before_action :allow_iframe

private

  def allow_iframe
    response.headers.delete "X-Frame-Options"
  end

  def set_locale
    I18n.locale = http_accept_language.compatible_language_from(I18n.available_locales)
  end
end
