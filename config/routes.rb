EcmaSh::Application.routes.draw do

  resources :sessions, only: [ :create, :delete ]
  resources :users, only: [ :create ]

  #get "/commands" - history
  #get "/commands/:id" - history
  #put "/commands/:id_num" - run historical command
  post "/commands/:id" => "commands#create"
  
  #get "/man"
  #get "/man/:id"

  
  #get "/home/*filepath"
  #get "/bin/*filepath"

  root to: "shells#new"
end
