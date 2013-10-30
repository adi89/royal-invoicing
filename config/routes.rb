require 'sidekiq/web'
Sherman::Application.routes.draw do

devise_for :users

root :to => 'home#index'

# resources :billing_docs, except: :index do
#   collection do
#     get '/:name(/:page)' => 'billing_docs#index', :as => :billing_category
#   end
# end

resources :billing_docs

post '/billing_docs/sort' => 'billing_docs#sort'
post '/see_all' => 'billing_docs#see_all'
resources :contacts

get '/add_line_item' => 'billing_docs#add_line_item'

mount Sidekiq::Web, at: "/sidekiq"
end
