resources :invitations, only: [:index, :create] do
  resources :acceptances, only: [:new, :create]
end

resource :team, only: :edit
