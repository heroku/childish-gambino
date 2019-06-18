class LoginsController < ApplicationController
  def create
    # Create new token and validate
    token = ResourceTokenCreator.new(
      heroku_uuid: heroku_uuid,
      timestamp: params[:timestamp],
    ).run

    # if invalid, 403
    if token != token_from_req
      render status: 403
    end

    # Display dashboard and render text

    resource = Resource.find_by(heroku_uuid: heroku_uuid)
    session[:resource_id] = resource.id
    #redirect_to heroku_dashboard_path(heroku_uuid)
    render plain: "Hello World!"
  end

  private

  def heroku_uuid
    params[:resource_id]
  end

  def token_from_req
    params[:resource_token]
  end
end
