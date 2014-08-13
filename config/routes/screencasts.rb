resources :screencasts, only: [], controller: "products" do
  resources :licenses, only: [:create]
end

get(
  ":id" => "products#show",
  as: :screencast,
  constraints: LicenseableConstraint.new(Screencast)
)
