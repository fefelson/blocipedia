Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  resources :wikis

  resources :users, only: [:show] do
    post '/downgrade' => 'users#downgrade', as: :downgrade
  end


  resources :charges, only: [:new, :create, :destroy]



  get 'welcome/index'

  get 'about' => 'welcome#about'

  root 'welcome#index'

end
