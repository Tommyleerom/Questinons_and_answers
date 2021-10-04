class User < ApplicationRecord

  has_secure_password # теперь у user помимо атрибутов записанных в схеме (email, name) есть и вирутеальные аттрибуты которые можно использовать как: u.password 'test', u.password_confirmation 'test', u.save, u.authenticate 'test' - если пароль не верный вернется false, если верный то user
  validates :email, presence: true, uniqueness: true # проверки на уровне приложения
  validates :name, presence: true

end
