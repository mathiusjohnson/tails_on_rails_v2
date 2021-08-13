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
  get 'new_link', to: 'links#new'
  get "previous_page", to: "links#previous_page"
  get "next_page", to: "links#next_page"
  post 'create_link', to: 'links#create'

  root to: "welcome#index"

end
