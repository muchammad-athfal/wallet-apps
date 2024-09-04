class ApplicationController < ActionController::API
  before_action :authenticate_user!

  private

  def authenticate_user!
    header = request.headers['Authorization']
    token = header.split(' ').last if header
    decoded = JsonWebToken.decode(token) if token

    if decoded && !JsonWebToken.blacklisted?(decoded[:jti])
      @current_user = User.find(decoded[:user_id])
    else
      render json: {
        status: false,
        message: 'Not authenticated or token blacklisted'
      }, status: :unauthorized
    end
  rescue StandardError => e
    render json: {
      status: false,
      message: "Not authenticated: #{e.message}" 
    }, status: :unauthorized
  end

  def current_user
    @current_user
  end
end
