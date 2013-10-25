Sherman::Application.routes.draw do

devise_for :users

root :to => 'home#index'

resources :billing_docs

get '/add_line_item' => 'billing_docs#add_line_item'

end
