Rails.application.routes.draw do
  devise_for :users

  if Rails.env.development?
    authenticate :user do
      mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql"
    end
  end
  
  authenticate :user do
    post "/graphql", to: "graphql#execute"
    
    get 'welcome/index'
    get "/links" => "links#index"
    get 'new_link', to: 'links#new'
    get "previous_page", to: "links#previous_page"
    get "next_page", to: "links#next_page"
    get "edit_link", to: "links#edit"
    post 'create_link', to: 'links#create'
    post 'update_link', to: 'links#update'
    delete 'delete_link', to: 'links#destroy'
  
    root to: "welcome#index"
  end


end
