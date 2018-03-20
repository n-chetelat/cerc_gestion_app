Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  root to: "static#form"

  scope "(:locale)", locale: /en|fr/ do
    get "/", to: "static#form"

    namespace "api", defaults: {format: "json"} do
      resources :positions, only: [:index] do
        get :form, on: :member
      end
    end
  end

end
