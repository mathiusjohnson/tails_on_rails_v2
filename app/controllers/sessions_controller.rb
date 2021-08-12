class SessionsController < ApplicationController
  def new
  end

  def create
    query_string = <<~GQL
      mutation {
        signinUser(
            credentials: {
              email:"dddddddas@j.com", 
              password: "123456"
            }
          ) {
          token
          user {
            id
          }
        }
      }
    GQL

    response = GraphqlTutorialSchema.execute(query: query_string)


    token = response.to_h["data"]["signinUser"]["token"]
    user_id = response.to_h["data"]["signinUser"]["user"]["id"]

    session[:token] = token
    user = current_user

    if logged_in?
      session[:user_id] = user_id
      flash[:success] = "You have successfully logged in"
      redirect_to root_path
    else
      flash.now[:error] = "There was something wrong with your login information"
      render 'new'
    end
  end

  def destroy
  end
end
