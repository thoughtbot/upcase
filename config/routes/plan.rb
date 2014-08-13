scope ":plan" do
  resources :checkouts, only: [:new, :create]
  resources :redemptions, only: [:new]
end
