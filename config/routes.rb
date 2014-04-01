GoalTracker::Application.routes.draw do
  root 'users#index'
  resources :users do
    resources :goals, only: [:new, :create, :index]
    post 'create', to: 'comments#create', as: 'new_comment'
  end
  resources :goals, except: [:new, :create, :index] do
    post 'complete', on: :member
    post 'reactivate', on: :member
    post 'create', to: 'comments#create', as: 'new_comment'
  end
  resource :session, only: [:new, :create, :destroy]
end
