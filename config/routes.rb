Rails.application.routes.draw do
  devise_for :users, skip: :all
  
  devise_scope :user do
    get 'login', to: 'devise/sessions#new', as: 'new_user_session'
    post 'login', to: 'devise/sessions#create', as: 'user_session'
    
    delete 'logout', to: 'devise/sessions#destroy', as: 'delete_user_session'
    
    post 'password', to: 'devise/passwords#create', as: 'user_password'
    get 'new_password', to: 'devise/passwords#new', as: 'new_user_password'
    get 'reset', to: 'devise/passwords#edit', as: 'edit_user_password'
    patch 'password', to: 'devise/passwords#update'
    put 'password', to: 'devise/passwords#update'
    
    
    
    
    
    get 'cancel', to: 'devise/registrations#cancel', as: 'cancel_user_registration'
    get 'signup', to: 'devise/registrations#new', as: 'new_user_registration'
    post 'signup', to: 'devise/registrations#create', as: 'user_registration'
    #get 'edit', to: 'devise/registrations#edit', as: 'edit_user_registration'
    #patch 'signup', to: 'devise/registrations#update'
    #put 'signup', to: 'devise/registrations#update'
    #delete 'signup', to: 'devise/registrations#destroy'
    
    post 'confirm', to: 'devise/confirmations#create', as: 'user_confirmation'
    get 'reconfirm', to: 'devise/confirmations#new', as: 'new_user_confirmation'
    get 'confirm', to: 'devise/confirmations#show'
  end
  
  #root 'devise/sessions#new'
  root 'profile#home'
  get 'add', to: 'stock#new', as: 'add_stock'
  post 'add', to: 'stock#create', as: 'stocks'
  
  get 'edit/:id', to: 'stock#edit', as: 'edit_stock'
  patch 'edit/:id', to: 'stock#update'
  delete 'destroy/:id', to: 'stock#destroy', as: 'destroy_stock'
  
  get 'portfolio', to: 'profile#portfolio', as: 'portfolio'
end
