require "sidekiq/web"

Rails.application.routes.draw do
  root "home#index"
  #get "edit"
  mount Sidekiq::Web => "/sidekiq"

  namespace :heroku do
    resources :resources, only: [:create, :destroy]
  end

  namespace :sso do
    resource :login, only: [:create]
  end
end
