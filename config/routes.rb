Rails.application.routes.draw do
  get '/employees/deleteConfirm', to: 'employees#deleteConfirm'
  resources :employees
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root 'pages#home'
  resources :users
  #The route for editing the requests is disabled for now
  resources :requests, except: [:edit]
end
