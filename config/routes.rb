Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/:primary/:secondary', to: 'home#index'

  root to: 'home#index'
end
