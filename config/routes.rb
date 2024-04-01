require 'sidekiq/web'
require 'sidekiq-status/web'

Rails.application.routes.draw do
  root to: "dashboard#index"

  resources :api_docs, only: [:index] do
    collection do
      get :api_v1
    end
  end

  namespace :api do
    namespace :v1 do
      resources :session, only: [:create] do
        collection do
          post :logout
        end
      end
    end
  end

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    passwords: 'users/passwords',
    confirmations: 'users/confirmations'
  }

  resources :users, only: [:index, :edit, :update, :show, :destroy]

  get 'dashboard/index'
  mount Sidekiq::Web => '/sidekiq'
end
