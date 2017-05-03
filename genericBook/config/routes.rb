Rails.application.routes.draw do
  devise_for :users, controllers: { :registrations => "users/registrations" },:path_prefix => 'me'
  resources :users, only: [:index]
  match 'users/:id' => 'users#profile', via: [:get], :as => :profile
  match 'users/:id/edit' => 'users#adminEdit', via: [:get], :as =>:adminEdit
  match 'users/:id/update' => 'users#update', via: [:patch], :as =>:update
  root to: "users#index"
#  authenticated :user do
#    root 'secret#index', as: :authenticated_root
#  end

#  root "devise#sign_in"
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
