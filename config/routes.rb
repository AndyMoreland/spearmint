Rails.application.routes.draw do
  root 'pages#index'

  resources :projects do
    resources :builds
  end
  
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  devise_scope :user do
      get 'sign_in', :to => 'users/devise/sessions#new', :as => :new_user_session
      delete 'sign_out', :to => 'users/devise/sessions#destroy', :as => :destroy_user_session
  end
end
