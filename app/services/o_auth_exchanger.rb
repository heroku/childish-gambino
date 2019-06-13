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
    puts "Updating resource: #{resource.id}"
    puts "responded with: #{response_body}"
    resource.update!(
      access_token: response_body[:access_token],
      refresh_token: response_body[:refresh_token],
      #access_token_expired_at: expired_at,
    )
    puts "resource access_token: #{resource.access_token}"
    puts "Resource id: #{resource.id} has been updated!"
  end

  private

  attr_accessor :client_secret, :resource_id

  def response_body
    @response_body ||= JSON.parse(request_to_heroku.body, symbolize_names: true)
  end

  def request_to_heroku
    HTTParty.post("#{BASE_URL}/oauth/token", query: body)
  end

  def body
    { "client_secret": client_secret,
     "code": resource.oauth_grant_code,
     "grant_type": GRANT_TYPE }
  end

  def resource
    Resource.find(resource_id)
  end

  def expired_at
    Time.now.utc
  end
end
