class BugzillaBug < ActiveRecord::Base

  include IndexedModel

  attr_accessible :number, :state, :system, :title, :description, :status
  attr_accessible :project
  attr_accessible :component
  attr_accessible :priority
  attr_accessible :severity
  attr_accessible :assignee
  attr_accessible :creator
  attr_accessible :version

  has_many :async_job

  index_options :extended_json=>:extended_index_attrs,
                :json=>{:only=> [:number, :state, :system, :title, :description]},
                :display_attrs => [:number, :state, :system, :title, :description]

  def extended_index_attrs
    {}
  end

  def reconcile_with_bugzilla
    # TODO implement me
  end

  def short_name
    "BZ #{self.number}"
  end

  def dependencies
    []

    # TODO: save dependency fields
    #json = JSON.parse(self.system_data)
    #deps = []
    #deps += json['depends_on']
    #deps += json['blocks']
    #deps
  end

  # load Bugzilla data from TaskMapper task
  def self.from_taskmapper(t)
    bz = BugzillaBug.new
    bz.state = t.status
    bz.number = t.id
    bz.title = t.title
    bz.project = t.project_id
    bz.component = t.component_id
    bz.priority = t.priority
    bz.severity = t.severity
    bz.assignee = t.assignee
    bz.creator = t.requestor
    bz.version = t.version
    bz.system = :bugzilla
    bz.description = t.summary
    #bz.system_data = (t.system_data)[:client].system_data.to_json
    bz.save

    bz
  end

end
