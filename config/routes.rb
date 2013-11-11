require 'sidekiq/web'
Sherman::Application.routes.draw do

  resources :groups do
    resources :invoices do
      collection do
        get 'sort' => 'invoices#sort'
      end
    end
    resources :estimates, except: :update
    resources :contacts do
      collection do
        get 'sort' => 'contacts#sort'
      end
    end
  end

  devise_for :users, :controllers => {:registrations => "registrations"}, :skip => [:sessions, :registrations]
  as :user do
  get 'login' => 'devise/sessions#new', :as => :new_user_session
  post 'login' => 'devise/sessions#create', :as => :user_session
  post '/users' => 'registrations#create', :as => :user_registration
  get '/users/sign_up' => 'registrations#new', :as => :new_user_registration
end

  # scope "groups/:group_id" do
  #   devise_for :users, :controllers => {:registrations => "registrations"}, :only =>
    # as :user do
    devise_scope :user do
      delete 'groups/:group_id/signout' => 'devise/sessions#destroy', :as => :destroy_user_session
      put 'groups/:group_id/cancel' => 'registrations#cancel', :as => :cancel_user_registration
      patch '/groups/:group_id/users' => 'registrations#update'
      put 'groups/:group_id/users' => 'registrations#update', :as => :update_registration
      delete 'groups/:group_id/users' => 'registrations#destroy'
      get 'groups/:group_id/users/edit' => 'registrations#edit', :as => :edit_user_registration
    end


  root :to => 'home#index'

  resources :companies
  # post 'groups/:group_id/invoices/sort' => 'invoices#sort'

  put 'groups/:group_id/estimates/:id' => 'estimates#update_estimate'

  get '/add_line_item_estimates' => 'estimates#add_line_item'
  get '/add_contact_estimate' => 'estimates#add_contact', :as => :add_contact_estimate

  post '/save_contact_estimate' => 'estimates#save_contact', :as =>
    :save_contact_estimate

  post '/paid_invoice' => 'invoices#paid_invoice', :as => :paid_invoice
  post '/make_invoice' => 'estimates#make_invoice', :as => :make_invoice

  # get '/groups/:group_id/contacts/sort' => 'contacts#sort'

  post '/contact_company' => 'contacts#company_ajax', :as => :company_ajax
  post '/save_company_data' => 'contacts#save_company_data', :as => :save_company_data

  get '/add_line_item' => 'invoices#add_line_item'

  mount Sidekiq::Web, at: "/sidekiq"
end