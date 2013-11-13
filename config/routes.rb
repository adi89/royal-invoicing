require 'sidekiq/web'
Sherman::Application.routes.draw do

  resources :groups do
    resources :contacts do
      collection do
        get 'sort' => 'contacts#sort'
      end
    end
    get '/:kind' => 'billing_docs#index', as: :billing_docs_kind
    post '/:kind' => 'billing_docs#create'
    get '/billing_docs/sort' => 'billing_docs#sort'
    get '/:kind/new' => 'billing_docs#new', as: :new_billing_doc
    resources :billing_docs, except: [:index, :new, :create]


  # /billing_docs/estimates
  # /bl
    # resources :invoices do
    #   collection do
    #     get 'sort' => 'invoices#sort'
    #   end
    # end
    # resources :estimates, except: :update
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

  # put 'groups/:group_id/estimates/:id' => 'estimates#update_estimate'

  get '/add_line_item_estimates' => 'estimates#add_line_item'

  post '/save_contact_estimate' => 'contacts#create', :as =>
    :save_contact_estimate

  post '/pay' => 'billing_docs#pay', :as => :pay

  post '/make_invoice' => 'billing_docs#make_into_invoice', :as => :make_into_invoice

  post '/contact_company' => 'companies#new'

  post '/save_company_data' => 'companies#create', :as => :save_company_data

  get '/add_line_item' => 'invoices#add_line_item'

  mount Sidekiq::Web, at: "/sidekiq"
end