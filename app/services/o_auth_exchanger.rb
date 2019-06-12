require "faraday"
require "httparty"

class Config
  def self.client_secret
    ENV.fetch("CLIENT_SECRET")
  end
end

class OAuthExchanger
  GRANT_TYPE = "authorization_code".freeze
  BASE_URL = "https://id.heroku.com".freeze

  def initialize(resource_id)
    @resource_id = resource_id
    @client_secret = Config.client_secret
  end

  def run
    response = request_to_heroku
    resource.update!(
      access_token: response[:access_token],
      refresh_token: response[:refresh_token],
      #access_token_expired_at: expired_at,
    )
  end

  private

  attr_accessor :client_secret, :resource_id

  def request_to_heroku
    JSON.parse(HTTParty.post("#{BASE_URL}/oauth/token", query: body), symbolize_names: true)
  end

  def body
    { "client_secret": client_secret,
     "oauth_grant_code": resource.oauth_grant_code,
     "grant_type": GRANT_TYPE }
  end

  def resource
    Resource.find(resource_id)
  end

  def expired_at
    Time.now.utc
  end
end
