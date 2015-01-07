get(
  ":id" => "shows#show",
  as: :show,
  constraints: LicenseableConstraint.new(Show)
)
