resources :trails, only: :index

get "/trails/completed" => "completed_trails#index", as: :completed_trails

get(
  ":id" => "trails#show",
  as: :trail,
  constraints: LicenseableConstraint.new(Trail)
)
