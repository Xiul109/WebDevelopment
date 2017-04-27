Rails.application.routes.draw do
  devise_for :users, controllers: { :registrations => "users/registrations" }
  resources :users, only: [:index]
  match 'profile/:id' => 'users#profile', via: [:get], :as => :profile
#  root "users/sessions#create"
#  authenticated :user do
#    root 'secret#index', as: :authenticated_root
#  end

#  root "devise#sign_in"
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
