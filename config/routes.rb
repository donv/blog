# frozen_string_literal: true

BlogEngine::Engine.routes.draw do
  root 'blogs#index'

  resources :blogs
  resources :blog_entries
  resources :images do
    member do
      get :thumbnail
    end
  end
  resources :users, path: 'user' do
    collection do
      get :forgot_password
      get :logout
      get :restore_deleted
      get :welcome
      post :change_password
      post :edit
      post :login
      post :signup
    end
    member do
      post :change_password
    end
  end
end
