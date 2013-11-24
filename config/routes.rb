EcmaSh::Application.routes.draw do

  resource :sessions, only: [ :create, :destroy]
  resources :registrations, only: [ :create, :show ]
  resources :guests, only: [ :create ]

  #get "/commands" - history
  #get "/commands/:id" - history
  #put "/commands/:id_num" - run historical command
  post "/commands/:id" => "commands#create"
  
  #get "/man"
  #get "/man/:id"

  
  #get "/bin/*filepath"

  post "/home/*directory" => "files#create", as: :create_file, format: false
  put "/home/*directory" => "files#update", as: :update_file, format: false
  get "/home/*directory" => "files#show", as: :file, format: false
  root to: "shells#new"
end
