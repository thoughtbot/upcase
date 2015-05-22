resources :videos, only: [:index, :show] do
  resource :twitter_player_card, only: [:show]
  resources :completions, only: [:create], controller: "video_completions"
end
