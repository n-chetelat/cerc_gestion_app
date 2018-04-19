require 'googleauth'
require 'sidekiq/web'
Rails.application.routes.draw do

  root to: "pages#home"

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  mount Sidekiq::Web => '/admin/sidekiq'

  get "/admin/google/authorize", to: "google#authorize"
  get "/correspondence/new", to: "correspondence#new"
  get "/correspondence/:person_id/fetch", to: "correspondence#fetch"

  scope "(:locale)", locale: /en|fr/ do

    namespace "api", defaults: {format: "json"} do

      resources :positions, only: [:index] do
        get :form, on: :member
      end
      resource :recruitment_info, only: [:show]
      resources :applications, only: [:index, :show, :create, :update]
      resources :persons, only: [:index, :show, :update, :delete] do
        scope module: "persons" do
          resource :email, only: [:show]
        end
      end
      resources :boards, only: [:show]
      resources :phases, only: [:index, :show] do
        scope module: "phases" do
          resources :persons, only: [:update]
        end
      end
      namespace :email do
        resources :threads, only: [:update]
      end
    end

  end

  match '/oauth2callback',
      to: Google::Auth::WebUserAuthorizer::CallbackApp,
      via: :all

  if Rails.env.production?
    get "*unmatched_route", to: redirect("/")
  end

end
