resources :quizzes, only: [:show] do
  resources :questions, only: [:show]
end
