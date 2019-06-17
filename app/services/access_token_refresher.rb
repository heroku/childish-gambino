# makes another request to heroku, similar to the oauth exchanger to obtain another token.
require "httparty"

class Config
  def self.client_secret
    ENV.fetch("CLIENT_SECRET")
  end
end

class AccessTokenRefresher
  GRANT_TYPE = "refresh_token".freeze
  BASE_URL = "https://id.heroku.com".freeze

  def initialize(resource_id)
    @resource_id = resource_id
    @client_secret = Config.client_secret
  end

  def run
    puts "The access token expires at: #{resource.access_token_expired_at}"
    puts "The time is now: #{Time.now.utc}"

    resource.update!(
      access_token: response_body[:access_token],
      refresh_token: response_body[:refresh_token],
      access_token_expired_at: access_token_expired_at,
    )
  end

  private

  attr_accessor :client_secret, :resource_id

  def response_body
    @response_body ||= JSON.parse(request_to_heroku.body, symbolize_names: true)
  end

  def request_to_heroku
    HTTParty.post("#{BASE_URL}/oauth/token", query: query)
  end

  def query
    { "client_secret": client_secret,
     "refresh_token": resource.refresh_token,
     "grant_type": GRANT_TYPE }
  end

  def resource
    Resource.find(resource_id)
  end

  def access_token_expired_at
    Time.now.utc + response_body[:expires_in]
  end
end
