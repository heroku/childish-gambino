class OAuthExchangeWorker
  include Sidekiq::Worker

  def perform(resource_id)
    puts "running worker"
    OAuthExchanger.new(resource_id).run
  end
end
