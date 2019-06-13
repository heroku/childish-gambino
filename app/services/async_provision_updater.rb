class AsyncProvisionUpdater
  BASE_URL = "https://api.heroku.com"

  def initialize(resource_id)
    @resource_id = resource_id
  end

  def run
    update_config_var
    mark_as_provisioned
    resource.update!(state: "provisioned")
  end

  private

  attr_reader :resource_id

  def update_config_var
    HTTParty.post(
      "#{BASE_URL}/oauth/token",
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
      "#{BASE_URL}/oauth/token",
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
