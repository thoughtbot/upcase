resources :shows, only: [] do
  resources :licenses, only: [:create]
end

get(
  ":id" => "shows#show",
  as: :show,
  constraints: LicenseableConstraint.new(Show)
)
