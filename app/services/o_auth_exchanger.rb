require "faraday"

class OAuthExchanger
  GRANT_TYPE = "authorization_code".freeze
  BASE_URL = "https://id.heroku.com".freeze

  def initialize(resource_id)
    @resource_id = resource_id
    @client_secret = ENV.fetch("CLIENT_SECRET")
  end

  def run
    resource.update!(
      access_token: response_body[:access_token],
      refresh_token: response_body[:refresh_token],
      access_token_expired_at: expired_at,
    )
  end

  private

  def request_to_heroku
    conn = Faraday.new(:url => BASE_URL) do |faraday|
      faraday.response :logger
    end

    conn.post "/oauth/token",
              { :client_secret => client_secret,
               :oauth_grant_code => resource.oauth_grant_code,
               :grant_type => GRANT_TYPE }
  end

  def response_body
    JSON.parse(request_to_heroku.body, symbolize_names: true)
  end

  def resource
    Resource.find(resource_id)
  end

  def expired_at
    Time.now.utc
  end
end
