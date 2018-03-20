Rails.application.routes.draw do

  root to: "pages#home"

  scope "(:locale)", locale: /en|fr/ do
    devise_for :admin_users, ActiveAdmin::Devise.config
    ActiveAdmin.routes(self)

    get "/", to: "pages#home"

    namespace "api", defaults: {format: "json"} do
      resources :positions, only: [:index] do
        get :form, on: :member
      end
      resource :recruitment_info, only: [:show]
    end
  end

  if Rails.env.production?
    get "*unmatched_route", to: redirect("/")
  end

end
