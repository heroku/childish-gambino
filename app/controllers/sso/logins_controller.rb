class Config
  def self.sso_salt
    ENV.fetch("SSO_SALT")
  end
end

class Sso::LoginsController < ApplicationController
  def create
    # Create new token and validate
    token = ResourceTokenCreator.new(
      heroku_uuid: heroku_uuid,
      timestamp: params[:timestamp],
      sso_salt: Config.sso_salt,
    ).run

    # if invalid, 403
    if token != token_from_req
      puts "Failed to SSO WITH heroku_uuid: #{heroku_uuid}, timestamp: #{timestamp}"
      render status: 403 and return
    end

    # Display dashboard and render text

    resource = Resource.find_by(heroku_uuid: heroku_uuid)
    session[:resource_id] = resource.id
    #redirect_to heroku_dashboard_path(heroku_uuid)
    render plain: "This is the dashboard for resource #: #{resource.id} \n With plan: #{resource.plan} \n State: #{resource.state}"
  end

  private

  def heroku_uuid
    params[:resource_id]
  end

  def token_from_req
    params[:resource_token]
  end
end
