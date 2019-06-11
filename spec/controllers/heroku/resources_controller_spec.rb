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

    it "returns a 202" do
      http_login(ENV["SLUG"], ENV["PASSWORD"])
      post :create, params: params

      expect(response.code).to eq("202")
    end

    it "has the correct JSON body" do
      http_login(ENV["SLUG"], ENV["PASSWORD"])
      expected = {
        id: heroku_id,
        message: "Hello! Your addon is being provisioned.",
      }

      post :create, params: params
      expect(JSON.parse(response.body, symbolize_names: true)).to eq(expected)
    end
  end
end
