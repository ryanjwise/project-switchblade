class ApiKeysController < ApplicationController
  include ApiKeyAuthenticatable

  prepend_before_action :authenticate_with_api_key!, only: [:index]
  prepend_before_action :authenticate_with_api_key, only: [:destroy]

  def index
    render json: current_bearer.api_keys
  end

  def create
    authenticate_with_http_basic do |email, password|
      user = User.find_by email: email

      if user&.authenticate(password)
        api_key = user.api_keys.create! token: SecureRandom.hex

        render json: api_key, status: :created and return
      end
    end
  end

  def destroy
    current_api_key&.destroy
  end
end