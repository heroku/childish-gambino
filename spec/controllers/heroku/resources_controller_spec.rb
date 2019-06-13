require "rails_helper"

RSpec.describe Heroku::ResourcesController do
  describe "POST /heroku/resources" do
    let(:name) { "childish-gambino" }
    let(:heroku_id) { SecureRandom.uuid }
    let(:plan) { "free" }
    let(:code) { "oauth-123" }
    let(:callback_url) { "www.google.com" }
    let(:oauth_grant) {
      {
        "code": code,
        "expires_at": "2016-03-03T18:01:31-0800",
        "type": "authorization_code",
      }
    }
    let(:options) { { "foo": "bar" } }
    let(:params) {
      {
        "callback_url": callback_url,
        "name": name,
        "oauth_grant": oauth_grant,
        "options": options,
        "plan": plan,
        "region": "aws::us-east",
        "uuid": heroku_id,
      }
    }
    before do
      Resource.create!(heroku_uuid: "123", plan: plan)
      http_login(ENV["SLUG"], ENV["PASSWORD"])
    end

    it "returns a 202" do
      post :create, params: params

      expect(response.code).to eq("202")
    end

    it "has the correct JSON body" do
      expected = {
        id: heroku_id,
        message: "Hey ERIC!!! CHILDISH_GAMBINO is being provisioned.",
      }

      post :create, params: params
      expect(JSON.parse(response.body, symbolize_names: true)).to eq(expected)
    end

    it "deletes the associated resource model" do
      delete :destroy, params: { "id": "123" }

      expect(Resource.find_by(heroku_uuid: "123")).to be_nil
    end
  end
end
