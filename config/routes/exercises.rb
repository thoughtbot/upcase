resources :exercises, only: [] do
  resource :trail, controller: "exercise_trails", only: [:show]
end
