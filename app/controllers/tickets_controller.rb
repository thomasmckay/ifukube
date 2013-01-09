class TicketsController < ApplicationController
  include AutoCompleteSearch

  require 'taskmapper'
  require 'taskmapper-bugzilla'
  require 'taskmapper-github'

  require 'cgi'  # for parsing URLs

  include TupaneHelper

  before_filter :find_filter, :only => [:index, :items, :edit]
  before_filter :setup_tupane, :only => [:index, :items, :create]

  def index

    # TODO: need to get rake reindex to work
    #Tire.index("_all").delete
    #BugzillaBug.index.import(BugzillaBug.all) if BugzillaBug.count > 0

    # TODO: just temporary to load up some tickets
    ticket = find_bz('886253')
    ticket = find_bz('873805')
    ticket = find_bz('837143')
  end

  def items
    # search can contain BZ id or BZ URL
    url = false
    if params[:search]
      if params[:search].starts_with?('https://bugzilla.redhat.com')
        url = true
        http_params = CGI::parse(URI.parse(params[:search]).query)
        params[:search] = http_params['id'][0]
      end
    end
    ticket = find_bz(params[:search]) if url || (number?(params[:search]))
    render_tupane(BugzillaBug, @tupane_options,
                   params[:search], params[:offset], split_order_param(params[:order]),
                   { :default_field => :number})
  end

  def edit
    bz_id = params[:id]
    bz_id ||= params[:search][:number]
    @ticket = find_bz(bz_id)
    tickets = [@ticket]
    @ticket.dependencies.each do |num|
      tickets << find_bz(num)
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
      :search_class  => BugzillaBug,

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

  def find_bz(id)
    Ticket.load_or_create(id, current_user)
  end

  def number?(search)
    return /^[\d]+$/ === search
  end

end
