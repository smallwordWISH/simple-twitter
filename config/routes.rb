Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_for :users

  # 請依照專案指定規格來設定路由
  root "tweets#index"

  resources :tweets, only: [:index, :create, :update, :destroy] do
    resources :replies, only: [:index, :create, :update, :destroy]

    member do
      post :like
      post :unlike
    end 

    collection do
      get :load
    end
  end

  resources :users, only: [:edit, :update] do

    member do 
      get :tweets
      get :followings
      get :followers
      get :likes      
    end
  end

  resources :followships, only: [:create, :destroy]

  namespace :admin do 
    resources :tweets, only: [:index, :destroy]
    resources :users, only: [:index]
    root "tweets#index"
  end
end
