class AsyncProvisionUpdater
  BASE_URL = "https://api.heroku.com"

  def initialize(resource_id)
    @resource_id = resource_id
  end

  def run
    if resource.access_token_expires_at + 60 < (Time.now.utc)
      AccessTokenRefresher.new(resource_id).run
    end

    update_config_var
    mark_as_provisioned
    resource.update!(state: "provisioned")
  end

  private

  attr_reader :resource_id

  def update_config_var
    HTTParty.patch(
      "#{BASE_URL}/addons/#{heroku_uuid}/config",
      headers: {
        "Accept" => "application/vnd.heroku+json; version=3",
        "Authorization" => "Bearer #{access_token}",
        "Content-Type" => "application/json",
      },
      body: JSON.dump(
        config: [
          {
            name: "CHILDISH_GAMBINO_URL",
            value: resource.plan,
          },
        ],
      ),
    )
  end

  def mark_as_provisioned
    HTTParty.post(
      "#{BASE_URL}/addons/#{heroku_uuid}/actions/provision",
      headers: {
        "Accept" => "application/vnd.heroku+json; version=3",
        "Authorization" => "Bearer #{access_token}",
        "Content-Type" => "application/json",
      },
    )
  end

  def heroku_uuid
    resource.heroku_uuid
  end

  def access_token
    resource.access_token
  end

  def resource
    Resource.find(resource_id)
  end
end
