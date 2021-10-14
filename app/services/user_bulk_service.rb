# frozen_string_literal: true

class UserBulkService < ApplicationService
  attr_reader :archive

  # rubocop:disable Lint/MissingSuper
  def initialize(archive_param)
    @archive = archive_param.tempfile # tempfile - метод который позволяет получить ссылку на загруженный файл (временный файл )
  end
  # rubocop:enable Lint/MissingSuper

  def call
    Zip::File.open(@archive) do |zip_file|
      zip_file.glob('*.xlsx').each do |entry|
        User.import users_from(entry), ignore: true # одна вставка в БД за один запрос, игнорировать дублирующие строки, валидации будут работать
        # Но на будущее данные операции нужно делать в фоновом режиме, чтобы сервер не завис и не сбросил соединение
      end
    end
  end

  private

  def users_from(entry)
    sheet = RubyXL::Parser.parse_buffer(entry.get_input_stream.read)[0]
    sheet.map do |row|
      cells = row.cells[0..2].map { |c| c&.value.to_s }
      User.new name: cells[0],
               email: cells[1],
               password: cells[2],
               password_confirmation: cells[2]
    end
  end
end
