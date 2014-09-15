resources :teams, only: :index
resource :team, only: :edit

resources :invitations, only: [:create, :destroy] do
  resources :acceptances, only: [:new, :create]
end
resources :memberships, only: [:destroy]
