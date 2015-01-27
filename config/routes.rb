Rails.application.routes.draw do
  post 'users/change_password' => 'users#change_password'
  post 'users/login' => 'users#login'

  root 'blogs#index'

  resources :blogs
  resources :blog_entries
  resources :images
  resources :users, path: 'user'

  get ':controller(/:action(/:id))'
end
