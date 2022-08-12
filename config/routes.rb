Rails.application.routes.draw do
  devise_for :users do
    get 'sign_in', to: 'devise/sessions#new'
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html


  root 'pages#home'
  get 'pages/home', to: "pages#home"

  # resources :projects do
  #     resources :bugs
  #   end
  # end
  resources :projects
  resources :bugs 
  
  # Defines the root path route ("/")
  # root "articles#index"
end
