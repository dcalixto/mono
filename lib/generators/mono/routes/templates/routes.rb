Rails.application.routes.draw do

  resources :posts
  resources :password_resets, controller: "password_resets", only: [:create, :new]
  resource :session, controller: "sessions", only: [:create]

  resources :users, controller: "users" do
    resource :password,
      controller: "passwords",
      only: [:create, :edit, :update]
  end

  get "/login" => "sessions#new", as: "login"
  delete "/logout" => "sessions#destroy", as: "logout"
  get "/signup" => "users#new", as: "signup"
  

 

end
