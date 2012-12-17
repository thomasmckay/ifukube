class TicketsController < ApplicationController

  require 'taskmapper'
  require 'taskmapper-bugzilla'
  require 'taskmapper-github'

  include TwopaneHelper

  before_filter :setup_twopane, :only => [:index, :items]

  def items
=begin
    tickets = []

    if params[:search].nil?
      ticket = Ticket.where(:system => :bugzilla, :number => '886253').first
      if !ticket && current_user.bugzilla_email
        bugzilla = TaskMapper.new(:bugzilla, {:username => current_user.bugzilla_email,
                                              :password => current_user.bugzilla_password,
                                              :url => 'https://bugzilla.redhat.com'})
        project = bugzilla.project('Subscription Asset Manager')
        t = project.ticket(886253)
        ticket = Ticket.from_taskmapper(t)
      end
      tickets << ticket unless ticket.nil?

      ticket = Ticket.where(:system => :github, :number => '1260').first
      if !ticket
        github = TaskMapper.new(:github, {:login => 'Katello'})
        project = github.project('katello')
        t = project.ticket(1260)
        ticket = Ticket.from_taskmapper(t)
      end
      tickets << ticket
    else
      tickets = Ticket.search params[:search]
    end
=end

    render_twopane(Ticket, @panel_options, 
                   params[:search], params[:offset], split_order_param(params[:order]),
                   { :default_field => :number, :filter => [{ :hidden => [false] }] })
  end

  def items
    #
  end

  private

  def setup_twopane
    @twopane_options = {
      :title => 'Tickets',
      :columns => ['number'],
      :titles => ['Number']
    }
  end

end
