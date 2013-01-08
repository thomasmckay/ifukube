class UsersController < ApplicationController
  include AutoCompleteSearch
  include TupaneHelper

  before_filter :setup_tupane, :only => [:index, :items, :create]

  def index
    # TODO: need to get rake reindex to work
    User.index.import(User.all) if User.count > 0

  end

  def items
    # TODO: for admin
    #if !params[:only] && User.any_readable?
    #  render_panel_direct(User, @panel_options, params[:search], params[:offset], [:username_sort, 'asc'],
    #                      { :default_field => :username,
    #                        :filter        => [{ :hidden => [false] }] })
    #else
    #  users = [@user]
    #  render_panel_items(users, @panel_options, nil, "0")
    #end

    users = [current_user]
    render_panel_items(users, @tupane_options, nil, "0")
  end

  def edit
    # TODO: hard coded to current_user

    @locals_hash = { :user => current_user }
    render :partial => 'edit', :locals => @locals_hash
  end

  def new
    # TODO: User.new
    # @locals_hash = { }
    # render :partial => 'new', :locals => @locals_hash
  end

  def create
    # TODO: User.create
  end

  def update
    # TODO: User.update
  end

  private

  def setup_tupane
    @tupane_options = {
      :name          => 'user',
      :accessor      => 'id',
      :search_class  => User,

      :title         => _('Users'),
      :columns       => ['email'],
      :titles        => [_('Email')],

      :enable_create => false,
      :create        => _('User'),
      :create_label  => _('+ Create'),

      :ajax_load     => true,
      :ajax_scroll   => items_users_path(),

      :custom_rows   => true,
      :list_partial  => 'users/list_users'
    }
  end

end
