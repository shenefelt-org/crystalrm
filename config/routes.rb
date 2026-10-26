Rails.application.routes.draw do
  resources :subscriptions
  resources :items
  resources :quotes
  resources :wikis
  resources :projects
  resources :customers
  devise_for :users

  authenticate :user do 
    get "up" => "rails/health#show", as: :rails_health_check
    mount MissionControl::Jobs::Engine, at: "/jobs"
    mount_avo
    root "home#index"
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

end
