require 'sidekiq/web'
Sherman::Application.routes.draw do

devise_for :users
root :to => 'home#index'

resources :companies
resources :invoices
resources :estimates, except: :update

put '/estimates/:id' => 'estimates#update_estimate'

get '/add_line_item_estimates' => 'estimates#add_line_item'

post '/paid_invoice' => 'invoices#paid_invoice', :as => :paid_invoice
post '/make_invoice' => 'estimates#make_invoice', :as => :make_invoice

post '/invoices/sort' => 'invoices#sort'
# post '/see_all' => 'invoices#see_all'
resources :contacts
post '/contact_company' => 'contacts#company_ajax', :as => :company_ajax
post '/save_company_data' => 'contacts#save_company_data', :as => :save_company_data

get '/add_line_item' => 'invoices#add_line_item'

mount Sidekiq::Web, at: "/sidekiq"
end
