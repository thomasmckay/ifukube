class TicketsController < ApplicationController

  require 'taskmapper'
  require 'taskmapper-bugzilla'
  require 'taskmapper-github'

  include TwopaneHelper

  before_filter :setup_twopane, :only => [:index, :items]

  def index

    # TODO: just temporary to load up some tickets
    ticket = Ticket.where(:system => :bugzilla, :number => '886253').first
    if !ticket && current_user.bugzilla_email
      bugzilla = TaskMapper.new(:bugzilla, {:username => current_user.bugzilla_email,
                                            :password => current_user.bugzilla_password,
                                            :url => 'https://bugzilla.redhat.com'})
      project = bugzilla.project('Subscription Asset Manager')
      t = project.ticket(886253)
      ticket = Ticket.from_taskmapper(t)
    end
    ticket = Ticket.where(:system => :github, :number => '1260').first
    if !ticket
      github = TaskMapper.new(:github, {:login => 'Katello'})
      project = github.project('katello')
      t = project.ticket(1260)
      ticket = Ticket.from_taskmapper(t)
    end
  end

  def items
    render_twopane(Ticket, @twopane_options,
                   params[:search], params[:offset], split_order_param(params[:order]),
                   { :default_field => :number})
  end

  private

  def setup_twopane
    @twopane_options = {
      :title         => 'Tickets',
      :columns       => ['number'],
      :titles        => ['Number'],
      :create_label  => _('+ New Ticket'),
      :name          => 'ticket',
      :ajax_load     => true,
      :ajax_scroll   => items_tickets_path(),
      :enable_create => true,
      :search_class  => Ticket
    }
  end

end
