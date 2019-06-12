module Heroku
  class ResourcesController < ApplicationController
    PROVISION_MESSAGE = "Hello! Your addon is being provisioned.".freeze
    STATE = "provisioning".freeze

    def create
      resource = Resource.create!(
        plan: params[:plan],
        region: params[:region],
        oauth_grant_code: params[:oauth_grant][:code],
        oauth_grant_expires_at: params[:oauth_grant][:expires_at],
        oauth_grant_type: params[:oauth_grant][:type],
        heroku_uuid: params[:uuid],
        state: STATE,
      )
      enqueue_token_job(resource.id)
      heroku_id = params[:uuid]

      render(
        json: {
          id: heroku_id,
          message: PROVISION_MESSAGE,
        }, status: 202,
      )
    end

    private

    def enqueue_token_job(resource_id)
      OAuthExchangeWorker.perform_async(resource_id)
    end
  end
end
