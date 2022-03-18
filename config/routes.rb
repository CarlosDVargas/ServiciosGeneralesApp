Rails.application.routes.draw do
  devise_for :users, controllers: {
        sessions: 'users/sessions',
        registrations: 'users/registrations'
      }

  get '/tasks/edit', to: 'tasks#edit', as: 'edit_task'
  post '/tasks/edit', to: 'tasks#update'
  resources :tasks

  resources :feedbacks

  get '/employees/deleteConfirm', to: 'employees#deleteConfirm'
  resources :employees
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root 'pages#home'
  
  #The route for editing the requests is disabled for now

  get '/requests/reports', to: 'requests#reports'
  get 'ask_state', to: 'requests#ask_state'
  post 'ask_state', to: 'requests#search_state'

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
