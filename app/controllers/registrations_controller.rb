# frozen_string_literal: true

class RegistrationsController < GraphqlController

  def create   
    @user = User.new(user_params)


    email = @user[:email]
    password = @user[:password_digest]

    if email && password != nil

      query_string = <<~GQL
        mutation {
          createUser(
            firstName: "mathius", 
            authProvider: {
              credentials: {
                email: "#{email}", 
                password: "#{password}"
              }
            }
          ) {
            user {
              email
            }
            token
          }
        }
      GQL

      response = GraphqlTutorialSchema.execute(query: query_string)

    end
    token = response.to_h["data"]["signinUser"]["token"]
    session[:token] = token

    flash[:notice] = "Welcome to the Alpha Blog #{@user.email}, you have successfully signed up"

    respond_to do |format|
      format.html do
        redirect_to '/'
      end
    end

  end

  private
  def user_params
    params.require(:session).permit(:email, :password)
  end

  def set_user
    @user = User.find(params[:id])
  end

end