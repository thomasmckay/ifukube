class AsyncJob < ActiveRecord::Base

  attr_accessible :sidekiq
  attr_accessible :action
  attr_accessible :updated_attributes

  belongs_to :user
  belongs_to :bugzilla_bug

  def self.save_bugzilla(user, number, attributes)

    # TODO: Let's not do anything rash before we're ready
    if number != "890963"
      error "Only BZ 890963 can be saved"
    end

    attributes.merge!({:ids => [number]})
    bz = BugzillaBug.find_by_number(number)

    job = AsyncJob.new(:action => 'save', :updated_attributes => attributes)
    job.user = user
    job.bugzilla_bug = bz
    job.save
    job.sidekiq = BugzillaWorker.perform_async(job.id)
    job.save

    job
  end
end
