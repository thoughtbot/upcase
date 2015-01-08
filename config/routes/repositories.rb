resources :repositories, only: [:index] do
  resource :collaboration, only: [:create]
end

get(
  ":id" => "repositories#show",
  as: :repository,
  constraints: SlugConstraint.new(Repository)
)
