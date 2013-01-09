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
      ticket = BugzillaBug.find_by_number(number)

      bugzilla = TaskMapper.new(:bugzilla, {:username => current_user.bugzilla_email,
                                            :password => current_user.bugzilla_password,
                                            :url => 'https://bugzilla.redhat.com'})
      t = bugzilla.ticket.find_by_id(number)

      attributes.merge!({:ids => [number]})

      # Map attributes
      if attributes.has_key? 'assignee'
        attributes['assigned_to'] = attributes['assignee']
        attributes.delete('assignee')
      end
      if attributes.has_key? 'state'
        attributes['status'] = attributes['state']
        attributes.delete('state')
      end

      r = t.send_update attributes
    end
  end

end
