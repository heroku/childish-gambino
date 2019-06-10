class OAuthExchangeWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(resource_id)
    # Call out to mediator class
    OAuthExchanger.new(resource_id: resource_id).run
  end
end
