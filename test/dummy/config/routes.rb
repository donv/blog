# frozen_string_literal: true

Rails.application.routes.draw do
  mount BlogEngine::Engine => '/blog'
end
