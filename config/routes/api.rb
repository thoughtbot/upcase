namespace :api do
  namespace :v1 do
    resources :completions, only: [:index, :show, :create, :destroy]
    resources :exercises, only: [:update]

    post "exercises/:exercise_uuid/status" => "statuses#create"
    post "videos/:video_wistia_id/status" => "statuses#create"
  end
end

get "/api/v1/me.json" => "api/v1/users#show", as: :resource_owner
