class BugzillaWorker
  include Sidekiq::Worker
  include Sidekiq::Status::Worker

  sidekiq_options :queue => :high
  sidekiq_options :retry => false

  def perform(job_id)
    job = AsyncJob.find(job_id)
    if job.action == 'refresh'
    elsif job.action == 'save'
      perform_save(job)
    end
  end

  private

  def perform_refresh
  end

  def perform_save(job)

    # TODO: bz.reconcile_with_bugzilla

    bz = job.bugzilla_bug
    if bz.number != "890963"
      error "Only BZ 890963 can be saved"
    end

    attributes = job.attributes
    attributes.merge!({:ids => [bz.number]})

    bugzilla = TaskMapper.new(:bugzilla, {:username => job.user.bugzilla_email,
                                          :password => job.user.bugzilla_password,
                                          :url => 'https://bugzilla.redhat.com'})
    t = bugzilla.ticket.find_by_id(bz.number)

    Sidekiq.logger.info "#{bz.short_name} - sending #{attributes}"
    #r = t.send_update attributes
    r = "SKIPPING"
    Sidekiq.logger.info "#{bz.short_name} - #{r}"
  end

end
