module Heroku
  class ResourcesController < ApplicationController
    PROVISION_MESSAGE = "Hello! Your addon is being provisioned.".freeze

    def create
      heroku_id = params[:id]
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
  end
end
