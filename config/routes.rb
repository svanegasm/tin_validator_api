Rails.application.routes.draw do
  get 'up' => 'rails/health#show', as: :rails_health_check

  namespace :api do
    namespace :v1 do
      resource :tin, only: %i[] do
        resources :validates, only: %i[index], controller: 'tin/validates'
      end
    end
  end
end
