require 'json'

class LinksController < GraphqlController

  def executeFromChild(args)
    query = args[:query]
    variables = args[:variables]
    context = args[:context]
    super(query, variables, context)
  end
  
  def index
    query_string = <<~GQL
      query {
        linksPaginated {
          pageInfo {
            hasNextPage
            hasPreviousPage
          }
          edges {
            cursor
            node {
              id
              url
              description
              postedBy {
                email
              }
              votes {
                id
              }
              createdAt
              updatedAt
            }
          }
        }
      }
    GQL

    response = executeFromChild(query: query_string, variables: nil, context: context)
    @data = JSON.parse(response)["data"]["linksPaginated"]

  end

  def show
    @link = Links.find(params[:id])
  end

  def new
    respond_to do |format|
        format.js { render partial: 'links/form' }
    end
  end

  def create
    url, description = new_link_params.values_at(:url, :description)
    create_link_query_string = <<~GQL
      mutation {
        createLink(
          url: "#{url}",
          description: "#{description}",
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

    response = executeFromChild(query: create_link_query_string,  variables: nil, context: context)
    
    flash[:notice] = "Link Successfully Created"
    redirect_to links_path
  end

  def next_page
    cursor = params["cursor"]

    query_string = <<~GQL
      query {
        linksPaginated(after: "#{cursor}") {
          pageInfo {
            hasNextPage
            hasPreviousPage
          }
          edges {
            cursor
            node {
              id
              url
              description
              postedBy {
                email
              }
              votes {
                id
              }
              createdAt
              updatedAt
            }
          }
        }
      }
    GQL

    response = executeFromChild(query: query_string, variables: nil, context: context)
    @data = JSON.parse(response)["data"]["linksPaginated"]
    render 'links/index'
  end

  def previous_page
    cursor = params["cursor"]
    query_string = <<~GQL
      query {
        linksPaginated(before: "#{cursor}") {
          pageInfo {
            hasNextPage
            hasPreviousPage
          }
          edges {
            cursor
            node {
              id
              url
              description
              postedBy {
                email
              }
              votes {
                id
              }
              createdAt
              updatedAt
            }
          }
        }
      }
    GQL

    response = executeFromChild(query: query_string, variables: nil, context: context)
    @data = JSON.parse(response)["data"]["linksPaginated"]
    render 'links/index'

  end

  def edit
    @variables = params["link"]
    respond_to do |format|
      format.js { render partial: 'links/form' }
    end
  end

  def update
    edit_query_string = <<~GQL
      mutation {
        updateLink(
          id: "#{params["id"]}", 
          description: "#{params["link"]["description"]}", 
          url: "#{params["link"]["url"]}"
        ) {
          id
          description
          url
        }
      }
    GQL

    response = JSON.parse(executeFromChild(query: edit_query_string, variables: nil, context: context))
    byebug

    if response["errors"][0]["message"] == "Invalid input: Url is too short (minimum is 5 characters)"
      respond_to do |format|
        flash[:alert] = "Url is too short (minimum is 5 characters)"
        format.js { render partial: 'links/form' }
      end
    else 
      flash[:alert] = "Link successfully updated"
      redirect_to links_path
    end
  end

  def destroy
    destroy_query_string = <<~GQL
      mutation {
        destroyLink(id: "#{params["id"]}")
        {
          id
          description
        }
      }
    GQL

    response = JSON.parse(executeFromChild(query: destroy_query_string, variables: nil, context: context))
    if response["data"] 
      flash[:alert] = "Link has been successfully deleted"
      redirect_to "/links"
    end
  end

  private
  def new_link_params
    params.require(:link).permit(:url, :description)
  end

end
