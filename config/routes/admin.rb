scope module: 'admin' do
  resources :users, only: [] do
    resource :masquerade, only: :create
  end
  resource :masquerade, only: :destroy
end

constraints Clearance::Constraints::SignedIn.new(&:admin?) do
  namespace :admin do
    resources :quizzes, only: [:new, :create, :show, :index] do
      resources :flashcards, only: [:new, :create, :edit, :update]
      resource :flashcard_preview, only: [:create]
      patch :flashcard_preview, to: "flashcard_previews#create"
    end
  end
end

mount RailsAdmin::Engine => "/admin", as: :admin
