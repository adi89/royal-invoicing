require 'sidekiq/web'
Sherman::Application.routes.draw do

devise_for :users

root :to => 'home#index'

# resources :billing_docs, except: :index do
#   collection do
#     get '/:name(/:page)' => 'billing_docs#index', :as => :billing_category
#   end
# end

resources :invoices
resources :estimates
# post '/estimates/sort' => 'estimates#sort'
# post '/see_all_estimates' => 'estimates#see_all'
get '/add_line_item_estimates' => 'estimates#add_line_item'

post '/make-invoice' => 'estimates#make_invoice', :as => :make_invoice

post '/invoices/sort' => 'invoices#sort'
# post '/see_all' => 'invoices#see_all'
resources :contacts

get '/add_line_item' => 'invoices#add_line_item'

mount Sidekiq::Web, at: "/sidekiq"
end
