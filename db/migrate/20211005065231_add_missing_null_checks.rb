# frozen_string_literal: true

class AddMissingNullChecks < ActiveRecord::Migration[6.1]
  def change
    change_column_null :questions, :title, false # указываем таблицу затем колонку и занчение null
    change_column_null :questions, :body, false
    change_column_null :answers, :body, false
    # все данные сохранятся
  end
end
