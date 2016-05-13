Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    confirmations: 'users/confirmations'
  }

  resources :wikis

  resources :users, only: [:show] do
    post :downgrade, on: :member
  end


  resources :charges, only: [:new, :create, :destroy]



  get 'welcome/index'

  get 'about' => 'welcome#about'

  root 'wikis#index'

end
