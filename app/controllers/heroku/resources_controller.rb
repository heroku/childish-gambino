module Heroku
  class ResourcesController < ApplicationController
    PROVISION_MESSAGE = "Hello! Your addon is being provisioned.".freeze
    STATE = "provisioning".freeze

    def create
      create_resource(STATE)
      heroku_id = params[:uuid]

      render(
        json: {
          id: heroku_id,
          config: {
            CHILDISH_GAMBINO_ADD_ON: "ON",
          },
          message: PROVISION_MESSAGE,
        }, status: 202,
      )
    end

    def create_resource(state)
      Resource.create!(
        plan: params[:plan],
        region: params[:region],
        oauth_grant_code: params[:oauth_grant][:code],
        oauth_grant_expires_at: params[:oauth_grant][:expires_at],
        oauth_grant_type: params[:oauth_grant][:type],
        heroku_uuid: params[:uuid],
        state: state,
      )
    end
  end
end
