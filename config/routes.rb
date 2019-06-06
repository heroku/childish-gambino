Rails.application.routes.draw do
  root "home#index"
  #get "edit"

  namespace :heroku do
    resources :resources, only: [:create]
  end
end
