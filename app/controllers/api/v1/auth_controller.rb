class Api::V1::AuthController < ApplicationController
  skip_before_action :authenticate_user!, only: [:create]
  
  def show
    render json: {
      status: true,
      message: 'Data Retrieved Successfully',
      data: UserSerializer.new(current_user).serializable_hash[:data][:attributes]
    }
  end

  def create
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      token = JsonWebToken.encode(user_id: user.id)
      render json: { 
        status: true,
        message: 'Logged in successfully',
        access_token: token, 
      }, status: :ok
    else
      render json: {
        status: false,
        message: 'Invalid email or password' 
      }, status: :unauthorized
    end
  end

  def destroy
    if current_user
      BlacklistedToken.create!(jti: current_token_jti)
      render json: {
        status: true,
        message: 'Logged out successfully' 
      }, status: :ok
    else
      render json: {
        status: false,
        message: 'Not authenticated' 
      }, status: :unauthorized
    end
  end

  private

  def current_token_jti
    auth_header = request.headers['Authorization']
    token = auth_header.split(' ').last if auth_header.present?
    decoded_token = JsonWebToken.decode(token) if token
    decoded_token['jti'] if decoded_token
  end
end
