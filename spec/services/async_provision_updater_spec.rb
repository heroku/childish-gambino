require "rails_helper"

RSpec.describe AsyncProvisionUpdater do
  describe "#run" do
    let!(:headers) {
      {
        "Accept" => "application/vnd.heroku+json; version=3",
        "Authorization" => "Bearer",
        "Content-Type" => "application/json",
      }
    }

    let(:access_token) { "fake-access-token" }
    let(:resource_id) { SecureRandom.uuid }
    let(:heroku_uuid) { SecureRandom.uuid }
    let!(:resource) { Resource.create!(heroku_uuid: heroku_uuid, plan: plan, oauth_grant_code: "123") }
    let(:plan) { "test" }
    let(:body) {
      JSON.dump(
        config: [
          {
            name: "CHILDISH_GAMBINO_URL",
            value: plan,
          },
        ],
      )
    }

    # it "updates the config var" do
    #   stub_request(:patch, "https://api.heroku.com/addons/#{heroku_uuid}/config")
    #     .with(
    #       body: body,
    #       headers: headers,
    #     )
    #     .to_return(status: 200, body: "")

    #   described_class.new(resource.id).run
    #   expect(WebMock).to have_requested(:patch, %r{/addons/#{heroku_uuid}/config"}).once
    # end

    # it "marks as provisioned" do
    #   stub_request(:post, "https://api.heroku.com/addons/#{heroku_uuid}/actions/provision")
    #     .with(
    #       headers: headers,
    #     )
    #     .to_return(status: 201)

    #   described_class.new(resource.id).run
    #   expect(WebMock).to have_requested(:post, %r{/addons/#{heroku_uuid}/actions/provision"}).once
    # end
  end
end
