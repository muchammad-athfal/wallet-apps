class ApplicationController < ActionController::API
  # include ActionController::Cookies
  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response

  before_action :authenticate_request
  SECRET_BASE_KEY = Rails.application.credentials.secret_base_key

  def current_user
    @current_user
  end

  private
  def authenticate_request
    header = request.headers['Authorization']
    token = header.split(' ').last if header

    decoded_token = decode_token(token)

    if decoded_token
      @current_user = User.find_by(id: decoded_token[:user_id])
      render json: {
        status: false,
        message: 'Invalid token',
      }, status: :unauthorized unless @current_user
    else
      render json: {
        status: false,  
        message: 'Token missing or invalid'
      }, status: :unauthorized
    end
  end

  def decode_token(token)
    return unless token
    JWT.decode(token, SECRET_BASE_KEY, true, algorithm: 'HS256').first.symbolize_keys
  rescue JWT::DecodeError
    nil
  end

  def render_unprocessable_entity_response(exception)
    render json: {
      errors: exception.record.errors.full_messages
    }, status: :unprocessable_entity
  end
end
