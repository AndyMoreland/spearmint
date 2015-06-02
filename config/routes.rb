Rails.application.routes.draw do
  root 'pages#index'

  resources :projects do
    resources :builds
  resources :settings
  end

  post '/hooks/:project_id', to: 'builds#create'
  
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  devise_scope :user do
    delete 'sign_out', :to => 'users/devise/sessions#destroy', :as => :destroy_user_session
  end
end
