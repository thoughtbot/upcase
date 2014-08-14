resources :workshops, only: [] do
  resources :licenses, only: [:create]
end

get(
  ":id" => "workshops#show",
  as: :workshop,
  constraints: LicenseableConstraint.new(Workshop)
)
