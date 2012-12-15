class ApplicationController < ActionController::Base
  protect_from_forgery

  require 'taskmapper'
  require 'taskmapper-bugzilla'
  require 'taskmapper-github'

  before_filter :authenticate_user!

  def index
  end

  def tickets
    tickets = []

    ticket = Ticket.where(:system => :bugzilla, :number => '886253').first
    if !ticket && ENV['BUGZILLA_USER']
      bugzilla = TaskMapper.new(:bugzilla, {:username => ENV['BUGZILLA_USER'], :password => ENV['BUGZILLA_PASSWD'], :url => 'https://bugzilla.redhat.com'})
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

    #render :partial=>'tickets', :locals=>{:tickets=>tickets}
    render :tickets, :locals=>{:tickets=>tickets}
  end
end
