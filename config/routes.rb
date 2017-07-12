Rails.application.routes.draw do

  root 'rates#show'
  resource :rates, only: :show
  namespace :admin do
    root 'indicators#index'
    resources :indicators
  end
end
