class ApplicationController < ActionController::Base
  include CanCan::ControllerAdditions

  layout :choose_layout
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  around_action :force_russian_locale

  rescue_from CanCan::AccessDenied do |_exception|
    redirect_to root_path, alert: "Недостаточно прав для этого действия."
  end

  private

  def current_ability
    @current_ability ||= Ability.new(current_user)
  end

  def choose_layout
    devise_controller? ? "album" : "application"
  end

  def force_russian_locale
    I18n.with_locale(:ru) { yield }
  end
end
