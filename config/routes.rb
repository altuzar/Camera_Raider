R4a::Application.routes.draw do

  resources :cameras

  ActiveAdmin.routes(self)
  root :to => "viewer#index"
  devise_for :users, :controllers => {:registrations => "registrations"}
  resources :users

  get '/viewer'  => 'viewer#index'
  get '/viewer/:sucursal'  => 'viewer#show'
  get '/view_detail/:sucursal'  => 'viewer#detail'

  get '/privacy'  => 'home#privacy'
  # get '/ayuda'    => 'home#ayuda'
  get '/get_out'    => 'home#get_out'
  get '/test'       => 'home#test'

end
