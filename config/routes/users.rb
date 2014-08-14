get "/sign_up" => "users#new", as: "sign_up_app"
get "/sign_in" => "sessions#new", as: "sign_in_app"

get "/my_account" => "users#edit", as: "my_account"
patch "/my_account" => "users#update", as: "edit_my_account"

resources :users, controller: "users" do
  resources :notes, only: [:create, :edit, :update]
  resource(
    :password,
    controller: "passwords",
    only: [:create, :edit, :update]
  )
end
resources :passwords, controller: "passwords", only: [:create, :new]
