scope ":plan" do
  resources :checkouts, only: [:new, :create]
end
