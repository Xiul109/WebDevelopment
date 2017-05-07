Rails.application.routes.draw do
  devise_for :users, controllers: { :registrations => "users/registrations" },:path_prefix => 'me'
  resources :users, only: [:index]
  resources :publications
  
  match 'users/me' => 'users#me', via: [:get], :as => :user_me
  match 'users/petitions' => 'users#petitions', via: [:get], :as =>:user_petitions
  match 'users/:id' => 'users#profile', via: [:get], :as => :user_profile
  match 'users/:id/edit' => 'users#edit', via: [:get], :as =>:user_edit
  match 'users/:id/update' => 'users#update', via: [:patch], :as =>:user_update
  match 'users/:id/delete' => 'users#delete', via: [:delete], :as =>:user_delete
  match 'users/:id/promote' => 'users#promote', via: [:patch], :as =>:user_promote
  
  match 'users/addFriend/:id' => 'users#addFriend', via: [:post], :as =>:user_addFriend
  match 'friendships/deny/:id' => 'friendships#deny', via: [:delete], :as => :friendships_deny
  match 'friendships/accept/:id' => 'friendships#accept', via: [:patch], :as => :friendships_accept
  match 'friendships/revoke/:id' => 'friendships#revoke', via: [:delete], :as => :friendships_revoke
  
  match 'publications/:id/share' => 'publications#share', via: [:post], :as => :share_publication
  match 'publications/:id/unshare' => 'publications#unshare', via: [:delete], :as => :unshare_publication

  match 'publications/:id/like' => 'publications#like', via: [:post], :as => :like_publication
  match 'publications/:id/dislike' => 'publications#dislike', via: [:delete], :as => :dislike_publication
  
  root to: "users#index"
#  authenticated :user do
#    root 'secret#index', as: :authenticated_root
#  end

#  root "devise#sign_in"
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
