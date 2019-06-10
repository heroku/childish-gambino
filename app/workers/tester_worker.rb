class TesterWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(plan_name)
    # Do something
    puts "hello from a test worker aka job"
    Resource.create!(plan: plan_name)
  end
end
