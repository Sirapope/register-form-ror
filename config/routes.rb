Rails.application.routes.draw do
  root 'users#register'
  get 'users/register', to: 'users#register'
  post 'users' ,to: 'users#create'
end
