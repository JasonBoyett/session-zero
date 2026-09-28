Rails.application.routes.draw do
  if Rails.env.development?
    mount Rswag::Api::Engine => "/api-docs"
    mount Rswag::Ui::Engine => "/api-docs"
  end

  devise_for :users, skip: :omniauth_callbacks
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  namespace :api do
    namespace :v1 do
      namespace :auth do
        post :login, to: "sessions#create"
        resource :session, only: %i[show create destroy]
        resource :me, only: %i[show], controller: :me
        patch :me, to: "me#update"

        devise_scope :user do
          namespace :oauth do
            post "/:provider", to: "oauth_callback#passthru"
            get "/:provider/callback", to: "oauth_callback#create"
            get "/failure", to: "oauth_callback#failure"
          end
        end
      end
    end
  end
end
