Rails.application.routes.draw do
  root 'users#index'

  get 'users/register'
  resources :users
end
