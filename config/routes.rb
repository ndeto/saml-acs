Rails.application.routes.draw do
  get 'saml/login', to: 'saml#login', as: 'login'
  post 'saml/acs',  to: 'saml#acs'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # post '/acs' => 'acs#'
  root 'home#index'
end
