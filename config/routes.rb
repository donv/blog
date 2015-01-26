Rails.application.routes.draw do
  post 'user/change_password' => 'user#change_password'

  root 'blogs#index'

  resources :blogs
  resources :blog_entries
  resources :images
  resources :users, path: 'user'

  get ':controller(/:action(/:id))'
end
