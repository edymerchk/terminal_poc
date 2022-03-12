Rails.application.routes.draw do
  resources :webhooks, only: [:create]

  namespace :v1 do
    resources :requests, only: [:create]
  end
end
