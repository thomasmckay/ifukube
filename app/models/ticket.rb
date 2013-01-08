require 'json'

# orchestration into bz bugs and taskmappers
class Ticket

  # load cached version from db, or load it from bz and save
  def self.load_or_create(id, user)
    bz = BugzillaBug.find_by_number(id) # load from db
    bz ||= create_bz_from_taskmapper(id, user) # load from bugzilla
    return bz
  end

  def self.create_bz_from_taskmapper(id, user)
    if user.bugzilla_email
      bugzilla = TaskMapper.new(:bugzilla, {:username => user.bugzilla_email,
                                            :password => user.bugzilla_password,
                                            :url => 'https://bugzilla.redhat.com'})

      t = bugzilla.ticket.find_by_id(id)
      bz = BugzillaBug.from_taskmapper(t)
      return bz
    else
      raise "you didnt configure"
    end
  end

end
