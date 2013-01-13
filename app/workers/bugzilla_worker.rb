class BugzillaWorker
  include Sidekiq::Worker
  sidekiq_options :queue => :high
  sidekiq_options :retry => true

  def perform(user_id, action, number, attributes={})
    Sidekiq.logger.info "abc"
    user = User.find(user_id)
    if action == 'refresh'
    elsif action == 'save'
      perform_save(user, number, attributes)
    end
  end

  private

  def perform_refresh
  end

  def perform_save(user, number, attributes)

    # TODO: bz.reconcile_with_bugzilla

    if number != "890963"
      error "Only BZ 890963 can be saved"
    end

    attributes.merge!({:ids => [number]})

    ticket = BugzillaBug.find_by_number(number)

    bugzilla = TaskMapper.new(:bugzilla, {:username => user.bugzilla_email,
                                          :password => user.bugzilla_password,
                                          :url => 'https://bugzilla.redhat.com'})
    t = bugzilla.ticket.find_by_id(number)

    Sidekiq.logger.info "#{ticket.short_name} - sending #{attributes}"
    #r = t.send_update attributes
    r = "SKIPPING"
    Sidekiq.logger.info "#{ticket.short_name} - #{r}"
  end

end
