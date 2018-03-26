Rails.application.routes.draw do

  root to: "pages#home"

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  scope "(:locale)", locale: /en|fr/ do

    namespace "api", defaults: {format: "json"} do
      resources :positions, only: [:index] do
        get :form, on: :member
      end
      resource :recruitment_info, only: [:show]
      resources :applications, only: [:index, :show, :create, :update, :delete]
      resources :persons, only: [:index, :show, :update, :delete]
    end
  end

  if Rails.env.production?
    get "*unmatched_route", to: redirect("/")
  end

end
