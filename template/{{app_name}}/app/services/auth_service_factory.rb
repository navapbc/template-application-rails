require "singleton"

class AuthServiceFactory
  include Singleton

  def initialize
    @auth_service =
      if ENV["AUTH_ADAPTER"] == "mock"
        AuthService.new(Auth::MockAdapter.new)
      else
        AuthService.new(Auth::CognitoAdapter.new)
      end
  end

  attr_reader :auth_service
end
