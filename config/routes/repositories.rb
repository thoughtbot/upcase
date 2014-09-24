resources :repositories, only: [:index] do
  resources :licenses, only: [:create]
end

get(
  ":id" => "repositories#show",
  as: :repository,
  constraints: LicenseableConstraint.new(Repository)
)
