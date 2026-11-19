Rails.application.routes.draw do
  root "skills#index"

  resources :skills
  get "/conflicts", to: "skills#conflicts", as: :conflicts

  get "up" => "rails/health#show", as: :rails_health_check
end
