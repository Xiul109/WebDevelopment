Rails.application.routes.draw do
  devise_for :users, controllers: { :registrations => "users/registrations" }
  
#  authenticated :user do
#    root 'secret#index', as: :authenticated_root
#  end

#  root "devise#sign_in"
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
