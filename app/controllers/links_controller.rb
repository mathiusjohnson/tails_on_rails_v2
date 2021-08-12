require 'json'

class LinksController < ApplicationController
  
  def index
    query_string = <<~GQL
      query {
        allLinks {
          id
          description
          postedBy {
            email
          }
          votes {
            user {
              email
            }
          }
        }
      }
    GQL
    context = {
      current_user: current_user
    }
    response = ProjectsSchema.execute(query: query_string, variables: nil, context: context)
    @data = response.to_h["data"]["allLinks"]
  end

  def show
    @link = Links.find(params[:id])
  end

  def create
    
    create_link_query_string = <<~GQL
      mutation {
        createLink(
          url: "https://www.link.ca",
          description: "Best tools leo!",
        ) {
          id
          url
          description
          postedBy {
            id
            email
          }
        }
      }
    GQL

    user = current_user
    response = ProjectsSchema.execute(query: create_link_query_string)

  end

end
