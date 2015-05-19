resources :quizzes, only: [:show, :index] do
  resources :questions, only: [:show]
  resource :results, only: [:show]
end

resources :questions, only: [] do
  resources :attempts, only: [:create]
end
