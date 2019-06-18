require "rails_helper"

RSpec.describe ResourceTokenCreator do
  describe "#run" do
    let(:resource_id) { "123" }
    let(:timestamp) { "456" }
    let(:sso_salt) { "salt-salt" }
    let(:expected_token) { Digest::SHA1.hexdigest(resource_id + ":" + sso_salt + ":" + timestamp).to_s }
    it "returns token based on the values passed in" do
      resource_token = ResourceTokenCreator.new(
        heroku_uuid: resource_id,
        timestamp: timestamp,
        sso_salt: sso_salt,
      ).run

      expect(resource_token).to eq(
        expected_token
      )
    end
  end
end
