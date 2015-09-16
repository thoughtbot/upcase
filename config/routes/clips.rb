resources :clips, only: [] do
  resource :download, only: [:show]
end
