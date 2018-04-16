class ApplicationController < ActionController::Base
  before_action :set_content, :set_locale

  def set_content
    @title = 'Destiny Weapons Comparison'
  end

  def set_locale
    I18n.locale = params[:lang] || I18n.default_locale
  end
end
