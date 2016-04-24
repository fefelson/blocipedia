Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  get 'welcome/index'

  get 'about' => 'welcome#about'

  root 'welcome#index'

end
