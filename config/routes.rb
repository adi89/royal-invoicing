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

  put 'groups/:group_id/estimates/:id' => 'estimates#update_estimate'

  get '/add_line_item_estimates' => 'estimates#add_line_item'

  post '/save_contact_estimate' => 'contacts#save_contact_to_estimate', :as =>
    :save_contact_estimate

  post '/pay' => 'invoices#pay', :as => :pay

  post '/make_invoice' => 'estimates#make_into_invoice', :as => :make_into_invoice

  post '/contact_company' => 'companies#new'

  post '/save_company_data' => 'companies#create', :as => :save_company_data

  get '/add_line_item' => 'invoices#add_line_item'

  mount Sidekiq::Web, at: "/sidekiq"
end