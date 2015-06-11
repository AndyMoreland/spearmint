Rails.application.routes.draw do
  get 'errors/file_not_found'

  get 'errors/unprocessable'

  get 'errors/internal_server_error'
  
  get '/projects_list', to: 'pages#index', as: 'projects_list'


  resources :projects do
    resources :builds, param: :number
    resources :trends, param: :statistic
    resources :reports, param: :source
    resources :ignored_issue_types, only: [:create, :destroy]
    match 'all_ignored_issue_types', to: 'ignored_issue_types#destroy_all', via: :delete
    resources :settings
  end

  post '/hooks/:project_id', to: 'builds#create'

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  devise_scope :user do
    get 'sign_in', to: redirect('/users/auth/github'), as: :new_user_session
    get 'sign_out', :to => 'users/devise/sessions#destroy', as: :destroy_user_session
  end

  match '/404', to: 'errors#file_not_found', via: :all
  match '/422', to: 'errors#unprocessable', via: :all
  match '/500', to: 'errors#internal_server_error', via: :all

  authenticated :user do
    root to: 'pages#index', :constraints => lambda { |r| r.env["warden"].authenticate? }
  end

  unauthenticated :user do
    get '/', to: 'pages#landing'
  end
end
