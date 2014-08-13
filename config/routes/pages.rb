get "/purchases/:lookup" => "pages#show", id: "purchase-show"

get "/pages/*id" => "pages#show", format: false
get "/subscribe" => "promoted_catalogs#show", as: :subscribe
get "/privacy" => "pages#show", as: :privacy, id: :privacy
get "/terms" => "pages#show", as: :terms, id: :terms
get "/directions" => "pages#show", as: :directions, id: :directions
get(
  "/group-training" => "pages#show",
  as: :group_training,
  id: "group-training"
)
get(
  "/rubyist-booster-shot" => "pages#show",
  as: :rubyist_booster_shot,
  id: "rubyist-booster-shot"
)
