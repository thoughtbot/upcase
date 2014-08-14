namespace :api do
  namespace :v1 do
    resources :completions, only: [:index, :show, :create, :destroy]
  end
end

get "/api/v1/me.json" => "api/v1/users#show", as: :resource_owner
