require 'jwt'

module JsonWebToken
  SECRET_KEY = Rails.application.credentials.jwt_secret || ENV['JWT_SECRET_KEY']

  def self.encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
		payload[:jti] = SecureRandom.uuid
    JWT.encode(payload, SECRET_KEY)
  end

  def self.decode(token)
    body = JWT.decode(token, SECRET_KEY)[0]
    HashWithIndifferentAccess.new(body)
  rescue JWT::DecodeError => e
    raise StandardError, "Invalid token: #{e.message}"
  end

	def self.blacklisted?(jti)
		BlacklistedToken.exists?(jti: jti)
	end
end
