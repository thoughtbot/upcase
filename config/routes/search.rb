constraints Clearance::Constraints::SignedIn.new(&:admin?) do
  resource :search, only: [:show, :create]
end
