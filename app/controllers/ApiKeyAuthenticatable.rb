module ApiKeyAuthenticatable
  extend ActiveSupport::Concern

  include ActionController::HttpAuthentication::Basic::ContollerMehtods
  include ActionController::HttpAuthentication::Token::ContollerMehtods

  attr_reader :current_api_key, :current_bearer

  # Return 401 HTTP status if authentication fails
  def authenticate_with_api_key!
    @current_bearer = authenticate_or_request_with_http_token(&method(:authenticator))
  end

  # Do not raise an error if no token is received, but do not return 401 HTTP status
  def authenticate_with_api_key
    @current_bearer = authenticate_with_http_token(&method(:authenticator))
  end

  private

  attr_writer :current_api_key
  attr_reader :current_bearer

  def authenticator(http_token, _options)
    @current_api_key = ApiKey.find_by token: http_token

    current_api_key.bearer
  end
end
