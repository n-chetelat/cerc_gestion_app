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

      resource :users, only: [:show] do
        get :auth
      end

      resources :positions, only: [:index] do
        get :form, on: :member
      end
      resource :recruitment_info, only: [:show]
      resources :applications, only: [:index, :show, :create, :update] do
        put :close, on: :member
        scope module: "applications" do
          resources :comments, only: [:index, :show, :create, :update, :destroy]
          resource :keywords, only: [:show, :update, :destroy]
        end
      end
      resources :persons, only: [:index, :show, :destroy] do
        scope module: "persons" do
          resource :email, only: [:show]
          resources :profile_fields, only: [:show, :create, :update]
          resources :positions_milestones, only: [:index]
        end
      end
      resources :boards, only: [:index, :show]
      resources :phases, only: [] do
        scope module: "phases" do
          resources :persons, only: [:update]
          resource :email_template, only: [:show]
        end
      end
      namespace :email do
        resources :threads, only: [:create, :update]
      end

      resources :profiles, only: [:index, :show, :create, :update] do
        put :finished, on: :member
      end
      resources :profile_fields, only: [:index]

      resources :milestones, only: [:index]
      resources :persons_positions_milestones, only: [:index, :show, :create, :update, :destroy]

      get "/semesters", to: "starting_dates#semesters"
      get "/months", to: "starting_dates#months"
      get "/timeline", to: "starting_dates#timeline"

      get "/keywords", to: "applications/keywords#autocomplete"
    end

  end

  match '/oauth2callback',
      to: Google::Auth::WebUserAuthorizer::CallbackApp,
      via: :all

  if Rails.env.production?
    get "*unmatched_route", to: redirect("/")
  end

end
