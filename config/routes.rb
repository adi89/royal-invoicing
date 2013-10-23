Sherman::Application.routes.draw do
  devise_for :users

root :to => 'home#index'

resources :billing_docs
end
