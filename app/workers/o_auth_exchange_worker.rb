class OAuthExchangeWorker
  include Sidekiq::Worker

  def perform(resource_id)
    OAuthExchanger.new(resource_id).run
  end
end
