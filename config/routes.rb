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
end
