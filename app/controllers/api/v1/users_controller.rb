class Api::V1::UsersController < ApplicationController

  api :POST, "/v1/users", "Create a new user"
  param :user, ["String", "Hash", "Json"], :desc => "User params requires json with 'email', 'password' and 'password_confirmation' string attributes to create a user. 'User created successfully' message will be returned on success"
  def create
    user = User.new(user_params)

    if user.save
      render json: {status: 'User created successfully'}, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :bad_request
    end
  end

  api :POST, '/v1/users/login', "Login to your user account. Once login is successful, 'auth_token' will be returned."
  param :email, String, :desc => "String email parameter"
  param :password, String, :desc => "String password parameter"
  def login
    user = User.find_by(email: params[:email].to_s.downcase)

    if user && user.authenticate(params[:password])
        auth_token = JsonWebToken.encode({user_id: user.id})
        render json: {auth_token: auth_token}, status: :ok
    else
      render json: {error: 'Invalid username / password'}, status: :unauthorized
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end