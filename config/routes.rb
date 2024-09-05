Rails.application.routes.draw do
  root 'users#index'

  get 'users/register', to: 'users#register'
  resources :users
end
