class BugzillaWorker
  include Sidekiq::Worker
  sidekiq_options queue: high
  sidekiq_options retry: true

  def perform(bz_id)
    bz = BugzillaBug.find(bz_id)
    bz.reconcile_with_bugzilla
  end

end
