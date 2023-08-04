Rails.application.routes.draw do
  resources :incidents, only: [:index, :create]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "incidents#index"
  post '/slack/command', to: 'slack_commands#receive'
end
