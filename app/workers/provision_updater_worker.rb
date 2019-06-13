class ProvisionUpdaterWorker
  include Sidekiq::Worker

  def perform(resource_id)
    AsyncProvisionUpdater.new(resource_id).run
  end
end
