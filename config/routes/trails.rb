get "/trails" => redirect("/practice")

get "/trails/completed" => "completed_trails#index", as: :completed_trails

get(
  ":id" => "trails#show",
  as: :trail,
  constraints: SlugConstraint.new(Trail)
)
