Rails.application.routes.draw do
  devise_for :users

  if Rails.env.development?
    authenticate :user do
      mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql"
    end
  end
  post "/graphql", to: "graphql#execute"
  
  get 'welcome/index'
  get "/links" => "links#index"
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  root to: "welcome#index"

end
