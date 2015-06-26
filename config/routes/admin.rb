scope module: 'admin' do
  resources :users, only: [] do
    resource :masquerade, only: :create
  end
  resource :masquerade, only: :destroy
end

constraints Clearance::Constraints::SignedIn.new(&:admin?) do
  namespace :admin do
    resources :decks, only: [:new, :create, :show, :index] do
      resources :flashcards, only: [:new, :create, :edit, :update]
      resource :flashcard_preview, only: [:create]
      patch :flashcard_preview, to: "flashcard_previews#create"
    end
  end
end

namespace :admin do
  resources :exercises
  resources :repositories
  resources :shows
  resources :plans

  DashboardManifest::DASHBOARDS.each do |resource_class|
    resources(
      resource_class,
      controller: :application,
      resource_class: resource_class,
    )
  end

  root(
    action: :index,
    controller: :application,
    resource_class: DashboardManifest::ROOT_DASHBOARD,
  )
end

