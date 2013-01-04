require 'json'

class Ticket < ActiveRecord::Base

  include IndexedModel

  attr_accessible :number, :state, :system, :title, :description, :status
  attr_accessible :project
  attr_accessible :component
  attr_accessible :priority
  attr_accessible :severity
  attr_accessible :assignee
  attr_accessible :creator
  attr_accessible :version

  index_options :extended_json=>:extended_index_attrs,
                :json=>{:only=> [:number, :state, :system, :title, :description]},
                :display_attrs => [:number, :state, :system, :title, :description]

  def extended_index_attrs
    {}
  end

  def product
    if self.is_bugzilla?
      return
    end
  end

  def self.from_taskmapper(t, ticket=nil)
    ticket = self.create if ticket.nil?
    ticket.state = t.status
    ticket.number = t.id
    ticket.title = t.title
    ticket.project = t.project_id
    ticket.component = t.component_id
    ticket.priority = t.priority
    ticket.severity = t.severity
    ticket.assignee = t.assignee
    ticket.creator = t.requestor
    ticket.version = t.version
    if t.is_a? TaskMapper::Provider::Github::Ticket
      ticket.system = :github
      ticket.description = t.title
      # TODO: need github raw data?
    elsif t.is_a? TaskMapper::Provider::Bugzilla::Ticket
      ticket.system = :bugzilla
      ticket.description = t.summary
      ticket.system_data = (t.system_data)[:client].system_data.to_json
    end
    ticket.save

    ticket
  end

  def is_bugzilla?
    self.system == 'bugzilla' || self.system == :bugzilla
  end

  def is_github?
    self.system == 'github' || self.system == :github
  end

  def short_name
    case self.system
      when 'bugzilla', :bugzilla
        "BZ #{self.number}"
      when 'github', :github
        "GIT #{self.number}"
      else
        "#{self.number}"
    end
  end

  def dependencies
    case self.system
      when 'bugzilla', :bugzilla
        json = JSON.parse(self.system_data)
        deps = []
        deps += json['depends_on']
        deps += json['blocks']
        deps
      when 'github', :github
        []
      else
        []
    end
  end
end
