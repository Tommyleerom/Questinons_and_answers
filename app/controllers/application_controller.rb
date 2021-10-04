class ApplicationController < ActionController::Base
  #protect_from_forgery with: :exception
  include Pagy::Backend
  include ErrorHandling

  private

  def current_user # устанавливаем текущего юзера через наличие сессии
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id].present?
  end

  def user_signed_in? # проверяем зарегестрирован ли текущий юзер
    current_user.present?
  end

  helper_method :current_user, :user_signed_in? # делаем данные методы еще и хелперами, чтобы они были доступны не только в контроллерах но и в представлениях
end
