namespace :subscriber do
  resources :invoices, only: [:index, :show]
  resource :cancellation, only: [:new, :create]
  resource :discount, only: :create
end
