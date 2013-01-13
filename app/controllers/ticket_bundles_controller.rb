class TicketBundlesController < ApplicationController

  require 'taskmapper'
  require 'taskmapper-bugzilla'
  require 'taskmapper-github'


  def create
    # TODO: this only handles bugzilla

    updates = {}
    params[:ticket_bundle].each do |param|
      field, ticket_id = param[0].split('_')
      updates[ticket_id] ||= {}
      updates[ticket_id].merge!({field => param[1]})
    end

    updates.each do |number, attributes|
      # Clean up attributes
      if attributes.has_key? 'assignee'
        attributes['assigned_to'] = attributes['assignee']
        attributes.delete('assignee')
      end
      if attributes.has_key? 'state'
        attributes['status'] = attributes['state']
        attributes.delete('state')
      end

      sync = BugzillaWorker.perform_async(current_user.id, :save, number, attributes)
    end
  end

end
