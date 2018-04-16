Rails.application.routes.draw do
  # Home
  root to: 'pages#index'

  # Search
  get '/search/:language', as: :autocomplete, to: 'search#autocomplete'
  get '/:first_weapon/:second_weapon', as: :search, to: 'search#compare'

  namespace :d1 do
    # Home
    root 'pages#index'

    # Search
    get '/search/:language', as: :autocomplete, to: 'search#autocomplete'
    get '/:first_weapon/:second_weapon', as: :search, to: 'search#compare'
  end
end
