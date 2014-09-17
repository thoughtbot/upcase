resources :books, only: [], controller: :products do
  resources :licenses, only: [:create]
end

get(
  ":id" => "products#show",
  as: :book,
  constraints: LicenseableConstraint.new(Book)
)

get '/backbone-js-on-rails' => redirect('https://gumroad.com/l/backbone-js-on-rails')
get '/geocoding-on-rails' => redirect('https://gumroad.com/l/geocoding-on-rails')
get '/ios-on-rails' => redirect('https://gumroad.com/l/ios-on-rails')
get '/ios-on-rails-beta' => redirect('https://gumroad.com/l/ios-on-rails')
get '/ruby-science' => redirect('https://gumroad.com/l/ruby-science')
