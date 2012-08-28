Chat::Application.routes.draw do
  resources :messages, except: :edit
  resources :users, except: :edit
  match "highest_user_id" => 'users#highest_id'
  match "highest_message_id" => 'messages#highest_id'
  root to: 'main#index'
end
