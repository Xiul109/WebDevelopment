Rails.application.routes.draw do
  devise_for :users, controllers: { :registrations => "users/registrations" },:path_prefix => 'me'
  resources :users, only: [:index]
  match 'users/:id' => 'users#profile', via: [:get], :as => :user_profile
  match 'users/:id/edit' => 'users#edit', via: [:get], :as =>:user_edit
  match 'users/:id/update' => 'users#update', via: [:patch], :as =>:user_update
  match 'users/:id/delete' => 'users#delete', via: [:delete], :as =>:user_delete
  match 'users/:id/promote' => 'users#promote', via: [:patch], :as =>:user_promote
  match 'users/addFriend/:id' => 'users#addFriend', via: [:post], :as =>:user_addFriend
  root to: "users#index"
#  authenticated :user do
#    root 'secret#index', as: :authenticated_root
#  end

#  root "devise#sign_in"
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
