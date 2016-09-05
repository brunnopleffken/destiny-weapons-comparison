Rails.application.routes.draw do

  get '/:first_weapon/:second_weapon', to: 'home#compare'
  root to: 'home#index'

end
