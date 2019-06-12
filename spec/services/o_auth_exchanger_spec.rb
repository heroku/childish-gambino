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
    let!(:resource) { Resource.create!(heroku_uuid: heroku_uuid, plan: plan, oauth_grant_code: oauth_grant_code) }
    let(:plan) { "test" }
    let(:body) {
      {
        "access_token": access_token,
        "refresh_token": refresh_token,
        "expires_in": 28800,
        "token_type": "Bearer",
      }
    }

    before do
      allow(Config).to receive(:client_secret).and_return(client_secret)
    end

    it "makes a request to heroku" do
      stub_request(:post, "https://id.heroku.com/oauth/token")
        .with(
          query: { "client_secret" => client_secret,
                   "oauth_grant_code" => oauth_grant_code,
                   "grant_type" => grant_type },
          headers: {
            "Accept" => "*/*",
            "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
            "User-Agent" => "Ruby",
          },
        )
        .to_return(status: 201, body: body.to_json)

      described_class.new(resource.id).run
      #binding.pry
      expect(WebMock).to have_requested(:post, %r{/oauth/token})
    end

    it "saves the access_token and refresh_token on the resource model" do
      stub_request(:post, "https://id.heroku.com/oauth/token")
        .with(
          query: { "client_secret" => client_secret,
                   "oauth_grant_code" => oauth_grant_code,
                   "grant_type" => grant_type },
          headers: {
            "Accept" => "*/*",
            "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
            "User-Agent" => "Ruby",
          },
        )
        .to_return(status: 201, body: body.to_json)

      described_class.new(resource.id).run
      expect(resource.reload.access_token).to eq access_token
      expect(resource.refresh_token).to eq refresh_token
    end
  end
end
