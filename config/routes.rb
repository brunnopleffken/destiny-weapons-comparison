Rails.application.routes.draw do
  # Home
  root to: 'home#index'

  # Search
  get '/search/:language', to: 'home#search_autocomplete'
  get '/:first_weapon/:second_weapon', to: 'home#compare'
end
