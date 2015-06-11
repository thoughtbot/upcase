resources :decks, only: [:show, :index] do
  resources :flashcards, only: [:show]
  resource :results, only: [:show]
end

resources :flashcards, only: [] do
  resources :attempts, only: [:create, :update]
end
