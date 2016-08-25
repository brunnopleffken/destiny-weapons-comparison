Rails.application.routes.draw do

  get '/:primary/:secondary', to: 'home#compare'
  root to: 'home#index'

end
