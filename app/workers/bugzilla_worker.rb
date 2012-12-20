class BugzillaWorker
  include Sidekiq::Worker
  sidekiq_options queue: high
  sidekiq_options retry: true

  def perform
  end

end
