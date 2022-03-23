Rails.application.routes.draw do

  root 'pages#home'
  
  devise_for :users, controllers: {
        sessions: 'users/sessions',
        registrations: 'users/registrations'
      }

  get '/tasks/edit', to: 'tasks#edit', as: 'edit_task'
  post '/tasks/edit', to: 'tasks#update'
  resources :tasks, except: [:show]

  resources :feedbacks

  get '/employees/deleteConfirm', to: 'employees#deleteConfirm'

  
  resources :employees

  post 'status_filter', action: :status_filter, controller: 'employees'
  
  
  get 'reports', to: 'requests#reports'
  get 'filter_reports', to: 'requests#filter_reports'


  get 'ask_state', to: 'requests#ask_state'
  post 'ask_state', to: 'requests#search_state'

  resources :requests do
    member do
      get :change_status
    end
  end
  
  post 'request_filter', action: :request_filter, controller: 'requests'

end
