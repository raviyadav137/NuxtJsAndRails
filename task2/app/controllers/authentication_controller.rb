# app/controllers/authentication_controller.rb
class AuthenticationController < ApplicationController

  def index
    @users = User.all
    render json: @users
  end


  def signup
    user = User.new(user_params)
    if user.save
      render json: { user: user }, status: :created
    else
      render json: { error: user.errors.full_messages }, status: :unprocessable_entity
    end
  end


  def login
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      token = encode_token(user_id: user.id)
      render json: {message:"user login sucessfully", user: user, token: token }, status: :ok
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end

  def update
    user = User.find_by(id: params[:id])
    if user.update(user_params)
      render json: { message: 'User updated', data: user }
    else
      render json: { message: 'Error updating user', data: user.errors }
    end
  end

  def logout
    user = User.find_by(email: params[:email]) # Assuming you have a method to fetch the current user
    if user
      user.destroy
      render json: { message: 'User data deleted successfully' }, status: :ok
    else
      render json: { error: 'User not found' }, status: :not_found
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :phone, :dob, :address)
  end

  def encode_token(payload)
    JWT.encode(payload, 'your_secret_key')
  end

end
