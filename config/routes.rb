Rails.application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }, :skip => [:password]
  resources :comments
  resources :users, :only => [:show, :update] do
    member do
      get 'init', to: 'users#init_new'
      patch 'init', to: 'users#init_update'
    end
  end
  resources :projects do
    member do
      post "/add_owner", :to => "projects#add_owner"
      get '/metrics/:metric', :to => 'projects#get_metric_data'
      get '/metrics/:metric/series', :to => 'projects#get_metric_series'
      get '/metrics/:metric/detail', to: 'projects#show_metric'
      get '/metrics/:metric/report', to: 'projects#show_report'
    end
  end
  resources :whitelists, :only => [:index] do
    member do
      put 'upgrade', to: 'whitelists#upgrade'
      put 'downgrade', to: 'whitelists#downgrade'
    end
  end
  resources :metric_samples, only: [:index] do
    member do
      get '/:metric/series', to: 'projects#get_metric_series'
      get '/:metric/detail', to: 'projects#show_metric'
      get '/:metric/report', to: 'projects#show_report'
    end
  end

  get '/metric_samples/:metric_sample_id/comments',
      :to => 'comments#comments_for_metric_sample',
      :as => 'metric_sample_comments'

  get '/login/:id', :to => 'application#passthru', :as => 'passthru'
  post '/log', to: 'projects#write_log'
  

  resources :iterations, :except => [:show]
  get '/iteration/:id', :to =>'iterations#show', :as=> 'show_iteration'
  get '/task/:iter/new', :to =>'task#new', :as => 'new_task_view'
  post '/task/:iter/create', :to =>'task#create', :as => 'create_new_task'
  get '/task/:id/edit', :to =>'task#edit', :as =>'edit_task'
  put '/task/:id', :to=>'task#update', :as =>'update_task'
  delete '/task/:id', :to=>'task#destroy'
  get '/iteration/student/show', :to=>'iterations#student_show', :as =>'student_iteration'
  get '/task/student/show/:iter', :to=>'student_task#index', :as =>'show_students_task'
  get '/task/publish/:iter', :to=>'task#publish', :as=>'publish_tasks'
  
  get '/student_task/index/:iter', :to=>'student_task#index', :as=>'team_index'
  get '/student_task/edit/:id', :to=>'student_task#edit', :as=>'edit_student_task'
  
  get '/student_task/showTeam/:iter/:team', :to=>'student_task#showATeamForInstructor', :as=>'show_a_team'
  put '/student_task/:id/edit', :to=>'student_task#saveChange', :as=>'save_student_task'
  get '/student_task/:team/new/:iter', :to=>'student_task#new', :as=>'new_student_task'
  put '/student_task/:team/new/:iter', :to=>'student_task#create', :as=>'create_new_student_task'
  delete '/student_task/:id/destroy', :to=>'student_task#destroy', :as=>'delete_student_task'
  get '/studenta_task/detail/:id', :to=>'student_task#detail', :as=>'detail_student_task'
  put '/iteration/:id/copy', :to=>'iterations#copy', :as=>'copy_iterations'
  put '/student_task/:id/status', :to=>'student_task#update_status', :as=>'update_status'
  
  put '/metric_samples/:id', :to => 'metric_samples#mark_read'
  put '/projects/:id/:metric/read_comments', :to => 'projects#metric_read'
  put 'projects/:id/:iteration_id/read_iteration_comments', :to => 'projects#iteration_read'
  put '/student_task/:id/read_comments', :to => 'student_task#task_read'
  get '/update_task/:id', :to=>'task_update#index', :as=>'detail_history'

  get 'user/import', :to=>'users#show_import', :as=>'show_import_users'
  post 'user/submit', :to=>'users#import', :as=>'submit_users'
  
  get 'import/projects', :to=>'projects#show_import', :as=>'show_import_projects'
  post 'submit/projects', :to=>'projects#import', :as=>'submit_projects'
  root 'projects#index'

end
