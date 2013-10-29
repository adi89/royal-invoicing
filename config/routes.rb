require 'sidekiq/web'
Sherman::Application.routes.draw do

devise_for :users

root :to => 'home#index'

resources :billing_docs
post '/billing_docs/sort' => 'billing_docs#index'
resources :contacts

get '/add_line_item' => 'billing_docs#add_line_item'

mount Sidekiq::Web, at: "/sidekiq"
end
