class ApplicationController < ActionController::Base
  protect_from_forgery

  require 'taskmapper'
  require 'taskmapper-bugzilla'

  before_filter :authenticate_user!

  def index
  end

  def bugzilla
    bugzilla = TaskMapper.new(:bugzilla, {:username => ENV['BUGZILLA_USER'], :password => ENV['BUGZILLA_PASSWD'], :url => 'https://bugzilla.redhat.com'})

    project = bugzilla.project('Subscription Asset Manager')
    #bugzilla.projects()

    Rails.logger.info("#{project.id}  #{project.name}")

    ticket = project.ticket(886253)

    render :bugzilla, :locals=>{:project=>project, :ticket=>ticket}
  end
end
