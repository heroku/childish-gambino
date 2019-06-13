require "rails_helper"

RSpec.describe ProvisionUpdaterWorker do
  describe "#perform" do
    it "calls the async provision updater class" do
      resource = Resource.create!(region: "US", heroku_uuid: 123, plan: "test", state: "provisioned")
      provision_worker = double(run: true)
      allow(AsyncProvisionUpdater).to receive(:new).and_return(provision_worker)

      provision_worker = ProvisionUpdaterWorker.new
      provision_worker.perform(resource.id)

      expect(AsyncProvisionUpdater).to have_received(:new).with(
        resource.id,
      )
    end
  end
end
