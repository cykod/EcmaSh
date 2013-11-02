EcmaSh::Application.routes.draw do
  devise_for :users

  #get "/commands" - history
  #get "/commands/:id" - history
  #put "/commands/:id_num" - run historical command
  post "/commands/:id" => "commands#create"
  
  #get "/man"
  #get "/man/:id"

  
  #get "/home/*filepath"
  #get "/bin/*filepath"
end
