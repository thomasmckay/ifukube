class Ticket < ActiveRecord::Base

  include Tire::Model::Search
  include Tire::Model::Callbacks

  attr_accessible :number, :state, :system, :title, :description

  def self.from_taskmapper(t)
    ticket = self.create
    ticket.state = t.state
    ticket.number = t.id
    ticket.title = t.title
    if t.is_a? TaskMapper::Provider::Github::Ticket
      ticket.system = :github
      ticket.description = t.title
    elsif t.is_a? TaskMapper::Provider::Bugzilla::Ticket
      ticket.system = :bugzilla
      ticket.description = t.summary
    end
    ticket.save

    ticket
  end
end
