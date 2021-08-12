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
    
    response = ProjectsSchema.execute(query: query_string)
    @data = response.to_h["data"]["allLinks"]
  end

  def show
    @link = Links.find(params[:id])
  end

end
