require "rails_helper"

RSpec.describe AsyncProvisionUpdater do
  describe "#run" do
    let(:access_token) { "fake-access-token" }
    let(:heroku_uuid) { SecureRandom.uuid }
    let!(:resource) {
      Resource.create!(
        heroku_uuid: heroku_uuid,
        oauth_grant_code: "123",
        access_token_expires_at: expired_time,
      )
    }
    let(:current_time) { Time.now.utc }
    let(:expired_time) { current_time - 10.minutes }

    context "access token has not expired" do
      let(:resource) {
        Resource.create!(
          heroku_uuid: heroku_uuid,
          access_token_expires_at: Time.now.utc + 1.day,
        )
      }

      it "updates the state to provisioned" do
        described_class.new(resource.id).run

        expect(resource.reload.state).to eq "provisioned"
      end
    end

    it "refreshes the access_token" do
      Timecop.freeze do
        refresher_double = double(run: true)
        allow(AccessTokenRefresher).to receive(:new).and_return(refresher_double)

        described_class.new(resource.id).run

        expect(AccessTokenRefresher).to have_received(:new).with(
          resource.id,
        )
      end
    end
  end
end
