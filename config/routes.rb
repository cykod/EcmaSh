EcmaSh::Application.routes.draw do

  resources :sessions, only: [ :create, :delete ]
  resources :registrations, only: [ :create, :show ]

  #get "/commands" - history
  #get "/commands/:id" - history
  #put "/commands/:id_num" - run historical command
  post "/commands/:id" => "commands#create"
  
  #get "/man"
  #get "/man/:id"

  
  #get "/home/*filepath"
  #get "/bin/*filepath"

  post "/home/*directory" => "files#create", as: :create_file
  get "/home/*directory" => "files#show", as: :file
  root to: "shells#new"
end
