require "rails_helper"

RSpec.describe OAuthExchangeWorker do
  describe "#perform" do
    it "calls the grant code exchanger class" do
      resource = Resource.create!(region: "US", heroku_uuid: 123, plan: "test", state: "provisioned")
      exchanger_double = double(run: true)
      allow(OAuthExchanger).to receive(:new).and_return(exchanger_double)

      # Why doesn't async work?
      #OAuthExchangeWorker.perform_async(resource.id)
      exchange_worker = OAuthExchangeWorker.new
      exchange_worker.perform(resource.id)

      expect(OAuthExchanger).to have_received(:new).with(
        resource.id,
      )
      expect(exchanger_double).to have_received(:run)
    end
  end
end
