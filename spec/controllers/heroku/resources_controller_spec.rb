require "rails_helper"

RSpec.describe Heroku::ResourcesController do
  describe "POST /heroku/resources" do
    it "returns a 201" do
      heroku_id = SecureRandom.uuid
      expected = {
        id: heroku_id,
        config: {
          CHILDISH_GAMBINO_ADD_ON: "ON",
        },
        message: "Hello! Your addon is being provisioned.",
      }

      post :create, params: { "id" => heroku_id }

      expect(response.code).to eq("202")
      expect(JSON.parse(response.body, symbolize_names: true)).to eq(expected)
    end
  end
end
