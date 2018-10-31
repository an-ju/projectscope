Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }, skip: [:password]
  resources :users, only: %I[show update] do
    member do
      get 'init', to: 'users#init_new'
      patch 'init', to: 'users#init_update'
    end
  end
  resources :projects do
    member do
      post '/add_owner', to: 'projects#add_owner'
      get '/metrics/:metric/detail', to: 'projects#show_metric'
    end
  end
  resources :whitelists, only: [:index] do
    member do
      put 'upgrade', to: 'whitelists#upgrade'
      put 'downgrade', to: 'whitelists#downgrade'
    end
  end
  resources :metric_samples, only: [:index] do
    member do
      get 'raw_data'
    end
  end

  get '/login/:id', to: 'application#passthru', as: 'passthru'
  post '/log', to: 'projects#write_log'

  resources :tasks
  resources :iterations
  get '/iterations/:iteration_id/delete_task/:task_id',
      to: 'iterations#delete_task', as: 'iteration_delete_task'

  post 'iterations/update_all',
       to: 'iterations#update_all', as: 'update_all_tasks'
  post 'iterations/create_task',
       to: 'iterations#create_task', as: 'create_task'
  post 'iterations/create_template_task',
       to: 'iterations#create_template_task', as: 'create_template_task'
  get 'aggregate_tasks_graph', to: 'iterations#aggregate_tasks_graph'
  post '/iterations/apply_to_all', to: 'iterations#apply_to_all', as: 'iterations_apply_to_all'
  post 'event/:callback_token/callback', to: "tasks#call_back_handler"
  get  'iterations/:id/show_template', to: "iterations#show_template", as: 'show_iter_temp'
  get  'iterations/:id/select_projects', to: "iterations#select_projects", as: 'iter_select_projs'
  get 'iterations/:id/delete_iteration', to: "iterations#delete_iteration", as: 'delete_iteration'
  post '/iterations/:iteration_id/edit_task/:task_id',
       to: 'iterations#edit_task', as: 'iteration_edit_task'
  post 'iterations/:id/confirm_assignment', to: "iterations#confirm_assignment", as: 'iter_confirm_info'
  get '/dashboard', to: "iterations#dashboard"

  root 'projects#index'
end
