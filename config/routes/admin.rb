scope module: 'admin' do
  resources :users, only: [] do
    resource :masquerade, only: :create
  end
  resource :masquerade, only: :destroy
end

mount RailsAdmin::Engine => "/admin", as: :admin
