Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  root to: "home#index"

  scope "(:locale)", locale: /en|fr/ do
    get "/", to: "home#index"
  end

end
