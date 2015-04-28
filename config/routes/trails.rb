get "/trails" => redirect("/practice")

get "/trails/completed" => "completed_trails#index", as: :completed_trails

resources :trails, only: [] do
  resource :progress_bar, only: [:show]
end

get(
  ":id" => "trails#show",
  as: :trail,
  constraints: SlugConstraint.new(Trail)
)
