Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resource :transport_time, only: :show
      resources :transport_stops, only: [:show]
      resources :transport_lines, only: [:show]
    end
  end
end
