get(
  ":id" => "trails#show",
  as: :trail,
  constraints: LicenseableConstraint.new(Trail)
)
