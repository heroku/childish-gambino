require "rails_helper"

RSpec.describe OAuthExchanger do
  describe "#run" do
    let(:client_secret) { "client-secret" }
    let(:oauth_grant_code) { "oauth-grant-code" }
    let(:grant_type) { "authorization_code" }
    let(:refresh_token) { "fake-refresh-token" }
    let(:access_token) { "fake-access-token" }
    let(:resource_id) { SecureRandom.uuid }
    let(:heroku_uuid) { SecureRandom.uuid }
    let!(:resource) { Resource.create!(heroku_uuid: heroku_uuid, plan: plan) }
    let(:plan) { "test" }
    let(:body) {
      {
        "access_token": access_token,
        "refresh_token": refresh_token,
        "expires_in": 28800,
        "token_type": "Bearer",
      }
    }

    it "makes a request to heroku" do
      stub_request(:post, %r(/oauth/token))
        .to_return(status: 201, body: "#{body}")

      described_class.new(resource.id).run

      expect(WebMock).to have_requested(:post, %r(/oauth/token)).once
    end

    it "saves the access_token and refresh_token on the resource model" do
      described_class.new(resource.id).run
      expect(resource.reload.access_token).to eq access_token_from_fixture
      expect(resource.refresh_token).to eq refresh_token_from_fixture
    end
  end
end
