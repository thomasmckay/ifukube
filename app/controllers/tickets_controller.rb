class TicketsController < ApplicationController
  include AutoCompleteSearch

  require 'taskmapper'
  require 'taskmapper-bugzilla'
  require 'taskmapper-github'

  require 'cgi'  # for parsing URLs

  include TupaneHelper

  before_filter :find_filter, :only => [:index, :items, :edit]
  before_filter :setup_tupane, :only => [:index, :items, :create]
  before_filter :find_ticket, :only => [:edit]

  def tmp_get_bugzilla(number)
    ticket = Ticket.where(:system => :bugzilla, :number => number.to_s).first
    # TODO: force update
    #if current_user.bugzilla_email
    if !ticket && current_user.bugzilla_email
      bugzilla = TaskMapper.new(:bugzilla, {:username => current_user.bugzilla_email,
                                            :password => current_user.bugzilla_password,
                                            :url => 'https://bugzilla.redhat.com'})
      project = bugzilla.project('Subscription Asset Manager')
      t = project.ticket(number.to_i)
      ticket = Ticket.from_taskmapper(t, ticket)
    end

    ticket
  end

  def index

    # TODO: need to get rake reindex to work
    #Tire.index("_all").delete
    #Ticket.index.import(Ticket.all) if Ticket.count > 0

    # TODO: just temporary to load up some tickets
    ticket = tmp_get_bugzilla('886253')
    ticket = tmp_get_bugzilla('873805')
    ticket = tmp_get_bugzilla('837143')
    ticket = Ticket.where(:system => :github, :number => '1260').first
    if !ticket
      github = TaskMapper.new(:github, {:login => 'Katello'})
      project = github.project('katello')
      t = project.ticket(1260)
      ticket = Ticket.from_taskmapper(t, ticket)
    end
  end

  def items
    if params[:search] && params[:search].starts_with?('https://bugzilla.redhat.com')
      http_params = CGI::parse(URI.parse(params[:search]).query)
      params[:search] = http_params['id'][0]
      ticket = tmp_get_bugzilla(params[:search])
    end
    render_tupane(Ticket, @tupane_options,
                   params[:search], params[:offset], split_order_param(params[:order]),
                   { :default_field => :number})
  end

  def edit
    tickets = [@ticket]
    @ticket.dependencies.each do |num|
      tickets << tmp_get_bugzilla(num)
    end

    @locals_hash = { :ticket => @ticket, :tickets => tickets, :filter => @filter }
    render :partial => 'edit', :locals => @locals_hash
  end

  def new
    @locals_hash = { }
    render :partial => 'new', :locals => @locals_hash
  end

  def create

    ticket = find_ticket

    if ticket
      # TODO: hook up notices, how?
      #notify.success _("%{ticket_name} created successfully") % {:ticket_name => ticket.short_name}
      # TODO: what should collection be here?
      locals_hash = { :ticket => @ticket, :accessor => @tupane_options[:accessor], :collection => [@ticket], :columns => @tupane_options[:columns] }
      render :partial => 'tickets/list_tickets', :locals => locals_hash
    else
      render :json => { :no_match => true }
    end
  end

  def update
    x = 1
  end

  private

  def setup_tupane
    @tupane_options = {
      :name          => 'ticket',
      :accessor      => 'id',
      :search_class  => Ticket,

      :title         => @filter ? @filter.name.capitalize : _('Tickets'),
      :columns       => ['number'],
      :titles        => [_('Ticket Number')],

      :enable_create => true,
      :create        => _('Ticket'),
      :create_label  => _('+ Edit'),

      :ajax_load     => true,
      :ajax_scroll   => items_tickets_path(),

      :custom_rows   => true,
      :list_partial  => 'tickets/list_tickets'
    }
  end

  def find_filter
    @filter = nil
    if params[:filter]
      @filter = Filter.find_by_name(params[:filter])
    end
  end

  def find_ticket
    if params[:id]
      @ticket = Ticket.find(params[:id])
      system = @ticket.system
      number = @ticket.number
    else
      system = params[:ticket][:system].downcase
      number = params[:ticket][:number]
      @ticket = Ticket.where(:system => :bugzilla, :number => number).first
    end

    if system == 'bugzilla'
      # TODO: temporarily always force update from
      if !@ticket && current_user.bugzilla_email
      #if current_user.bugzilla_email
        bugzilla = TaskMapper.new(:bugzilla, {:username => current_user.bugzilla_email,
                                              :password => current_user.bugzilla_password,
                                              :url => 'https://bugzilla.redhat.com'})

        t = bugzilla.ticket.find_by_id(number)
        @ticket = Ticket.from_taskmapper(t, @ticket)
      end
    elsif system == 'github'
      # TODO: temporarily always force update from
      if !@ticket
      #if true
        github = TaskMapper.new(:github, {:login => 'Katello'})
        project = github.project('katello')
        t = project.ticket(number)
        @ticket = Ticket.from_taskmapper(t, @ticket)
      end
    end

    @ticket
  end

end
