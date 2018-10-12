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

  root 'projects#index'
end
