class TicketsController < ApplicationController
  include AutoCompleteSearch

  require 'taskmapper'
  require 'taskmapper-bugzilla'
  require 'taskmapper-github'

  include TupaneHelper

  before_filter :setup_tupane, :only => [:index, :items]
  before_filter :find_ticket, :only => [:edit]

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
    render_tupane(Ticket, @tupane_options,
                   params[:search], params[:offset], split_order_param(params[:order]),
                   { :default_field => :number})
  end

  def edit
    @locals_hash = { :ticket => @ticket }
    render :partial => 'edit', :locals => @locals_hash
  end

  def new
    @locals_hash = { }
    render :partial => 'new', :locals => @locals_hash
  end

  private

  def setup_tupane
    @tupane_options = {
      :name          => 'ticket',
      :search_class  => Ticket,

      :title         => 'Tickets',
      :columns       => ['number'],
      :titles        => ['Ticket Number'],

      :enable_create => true,
      :create        => _('Ticket'),
      :create_label  => _('+ New Ticket'),

      :ajax_load     => true,
      :ajax_scroll   => items_tickets_path(),

      :custom_rows   => true,
      :list_partial  => 'tickets/list_tickets'
    }
  end

  def find_ticket
    @ticket = Ticket.find(params[:id])
  end

end
