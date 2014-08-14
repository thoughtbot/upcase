resources :books, only: [], controller: :products do
  resources :licenses, only: [:create]
end

get(
  ":id" => "products#show",
  as: :book,
  constraints: LicenseableConstraint.new(Book)
)
