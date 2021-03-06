Rails.application.routes.draw do
  # Home: select D1 or D2
  root to: 'pages#index'

  namespace :d1 do
    # Home
    root 'pages#index'
    # Search
    get '/search/:language', as: :autocomplete, to: 'search#autocomplete'
    get '/:first_weapon/:second_weapon', as: :search, to: 'search#compare'
  end

  namespace :d2 do
    # Home
    root 'pages#index'
    # Search
    get '/search/:language', as: :autocomplete, to: 'search#autocomplete'
    get '/:first_weapon/:second_weapon', as: :search, to: 'search#compare'
  end
end
