Rails.application.routes.draw do
  resources :tasks
  get '/employees/deleteConfirm', to: 'employees#deleteConfirm'
  resources :employees
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root 'pages#home'
  resources :users
  #The route for editing the requests is disabled for now

  get '/requests/reports', to: 'requests#reports'

  resources :requests do
    member do
      get :change_status
    end
  end
  
  resources :employees do
    collection do
      get :statusfilter
    end
  end
end
