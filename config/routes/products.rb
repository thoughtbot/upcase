resources :products, only: [:index] do
  resources :licenses, only: [:create]
end
