get(
  ":id" => "shows#show",
  as: :show,
  constraints: SlugConstraint.new(Show)
)
