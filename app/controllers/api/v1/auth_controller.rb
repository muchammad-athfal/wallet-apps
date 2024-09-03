class Api::V1::AuthController < ApplicationController
  skip_before_action :authenticate_request

  def create
    user = User.find_by(email: params[:email])
    
    if user && user.authenticate(params[:password])
      token = generate_token(user)
      render json: {
        status: true,
        message: 'Logged in successfully',
        access_token: token 
      }, status: :ok
    else
      render json: {
        status: false,
        message: 'Invalid email or password'
      }, status: :unauthorized
    end
  end

  private

  def generate_token(user)
    JWT.encode({ user_id: user.id, exp: 24.hours.from_now.to_i }, SECRET_BASE_KEY, 'HS256')
  end
end
