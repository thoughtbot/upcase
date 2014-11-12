get "/purchases/:lookup" => "pages#show", id: "purchase-show"

get "/pages/*id" => "pages#show", format: false
get "/privacy" => "pages#show", as: :privacy, id: 'privacy'
get "/terms" => "pages#show", as: :terms, id: 'terms'
