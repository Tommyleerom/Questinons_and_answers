# frozen_string_literal: true

Rails.application.routes.draw do

  scope '(:locale)', locale: /#{I18n.available_locales.join("|")}/ do # теперь в пути localhost:3000/questions может стоять локализация localhost:3000/ru/questions из доступных локалей (а может и не стоять, для этого мы используем - () )
    root 'pages#index'

    resource :session, only: %i[new create destroy] # resource - в единственном
    # числе чтобы в маршруте не требовался идентификатор /:id/

    resources :users, only: %i[new create edit update]

    resources :questions do
      resources :answers, only: %i[create destroy edit update]
    end

    namespace :admin do # удобно т.к. логику админа мы будем описывать в отдельном контроллере users
      resources :users, only: %i[index create]
    end
  end
end

# index - запрашивает все элементы из БД и записывает в переменную @elements,
# а в index.html.erb - уже доступна переменная @elements

# new - записывет в память один элемент, для последующего сохранения через
# create, а в new.html.erb отображается сама форма для записи элемента в память
# create - логика сохранения элемента из new в БД

# edit - отображает форму для редактирования конкретного элемента,
# а в edit.html.erb отображается форма для редактирования
# update - обработывает эту форму и сохраняет в БД
# show - отображает конкретный элемент

# destroy - уничтожает элемент
