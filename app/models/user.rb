# frozen_string_literal: true

class User < ApplicationRecord
  attr_accessor :old_password, :remember_token # это виртуальный аттрибут

  # (как и has_secure_password) и в БД он попадать не будет, он нужен для
  # работосопособности поля с вводом старого пароля в форме _from.html.erb

  has_secure_password validations: false # отключаем встроенные валидации чтобы
  # написать их вручную и дополнить своими

  # теперь у user помимо атрибутов записанных в схеме (email, name) есть и
  # вирутеальные аттрибуты которые можно использовать как: u.password 'test',
  # u.password_confirmation 'test', u.save, u.authenticate 'test' - если пароль
  # не верный вернется false, если верный то user

  validate :password_presence
  validate :correct_old_password, on: :update, if: -> { password.present? }
  # применять данную валидацию только при использовании метода update, и только
  # в том случае если пароль указан в форме (т.е эта валидация будет
  # использоваться только при смене пароля, а при смене имени и
  # e-mail'а не будет и пароль вводить не нужно)

  validates :password, confirmation: true, allow_blank: true, length: { minimum: 3, maximum: 70 }

  validates :email, presence: true, uniqueness: true # проверки на уровне приложения

  # запоминаем пользователя в БД
  def remember_me
    # пристыкуем с помощью self remember_token к текущему юзеру
    self.remember_token = SecureRandom.urlsafe_base64
    # rubocop:disable Rails/SkipsModelValidations
    update_column :remember_token_digest, digest(remember_token)
    # rubocop:enable Rails/SkipsModelValidations
  end

  def forget_me
    # rubocop:disable Rails/SkipsModelValidations
    update_column :remember_token_digest, nil
    # rubocop:enable Rails/SkipsModelValidations
    self.remember_token = nil
  end

  # проверяем запоминался ли данный пользователь
  def remember_token_authenticated?(remember_token)
    return false if remember_token_digest.blank?

    BCrypt::Password.new(remember_token_digest).is_password?(remember_token)
  end

  private

  def digest(string)
    cost = if ActiveModel::SecurePassword
              .min_cost
             BCrypt::Engine::MIN_COST
           else
             BCrypt::Engine.cost
           end
    BCrypt::Password.create(string, cost: cost)
  end

  def password_presence
    errors.add(:password, :blank) if password_digest.blank? # проверяем если пароль в БД
  end

  def correct_old_password
    return if BCrypt::Password.new(password_digest_was).is_password?(old_password)

    errors.add :old_password, 'is incorrect'
  end
end
