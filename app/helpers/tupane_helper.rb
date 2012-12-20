module TupaneHelper
  # search_options
  #    :default_field - The field that should be used by the search engine when a user performs
  #                     a search without specifying field.
  #    :filter  -  Filter to apply to search. Array of hashes.  Each key/value within the hash
  #                  is OR'd, whereas each HASH itself is AND'd together
  #    :load  - whether or not to load the active record object (defaults to false)
  def render_tupane(obj_class, tupane_options, search, start, sort, search_options={})

    filters = search_options[:filter] || []
    load = search_options[:load] || false
    all_rows = false
    skip_render = search_options[:skip_render] || false
    page_size = search_options[:page_size] || current_user.page_size
    start ||= 0

    if search.nil? || search== ''
      all_rows = true
    elsif search_options[:simple_query] && !AppConfig.simple_search_tokens.any?{|s| search.downcase.match(s)}
      search = search_options[:simple_query]
    end

    # set the query default field, if one was provided.
    query_options = {}
    query_options[:default_field] = search_options[:default_field] unless search_options[:default_field].blank?

    tupane_options[:accessor] ||= "id"
    tupane_options[:initial_action] ||= :edit

    @items = []

    begin
      results = obj_class.search :load=>false do
        query do
          if all_rows
            all
          else
            string search, query_options
          end
        end

        sort {by sort[0], sort[1].to_s.downcase } unless !all_rows

        filters = [filters] if !filters.is_a? Array
        filters.each{|i|
          filter  :terms, i
        } if !filters.empty?

        size page_size if page_size > 0
        from start
      end

      if load
        @items = obj_class.where(:id=>results.collect{|r| r.id})
        #set total since @items will be just an array
        tupane_options[:total_count] = results.empty? ? 0 : results.total
        if @items.length != results.length
          Rails.logger.error("Failed to retrieve all #{obj_class} search results " +
                             "(#{@items.length}/#{results.length} found.)")
        end
      else
        @items = results
      end

      #get total count
      total = obj_class.search do
        query do
          all
        end
        filters.each{|i|
          filter  :terms, i
        } if !filters.empty?
        size 1
        from 0
      end
      total_count = total.total

    rescue Tire::Search::SearchRequestFailed => e
      Rails.logger.error(e.class)

      total_count = 0
      tupane_options[:total_results] = 0
    end

    render_panel_results(@items, total_count, tupane_options) if !skip_render
    return @items
  end

  def render_panel_results(results, total, options)
    options[:total_count] ||= results.empty? ? 0 : results.total
    options[:total_results] = total
    options[:collection] = results
    @items = results

    if options[:list_partial]
      rendered_html = render_to_string(:partial=>options[:list_partial], :locals=>options)
    elsif options[:render_list_proc]
      rendered_html = options[:render_list_proc].call(@items, options)
    else
      rendered_html = render_to_string(:partial=>"common/tupane_list_items", :locals=>options)
    end



    render :json => {
      :html => rendered_html,
      :results_count => options[:total_count],
      :total_items => options[:total_results],
      :current_items => options[:collection].length
    }

    # TODO: user saved search history
    #retain_search_history unless options[:no_search_history]

  end

  def render_panel_items(items, options, search, start)
    @items = items

    options[:accessor] ||= "id"
    options[:initial_action] ||= :edit

    if start == "0"
      options[:total_count] = @items.count
    end

    # the caller may provide items either based on active record or a list within an array... in the case of an
    # array, it is assumed to be based upon results from a pulp/candlepin request, in which case search is
    # not currently supported
    if @items.kind_of? ActiveRecord::Relation
      items_searched = @items.search_for(search)
      items_offset = items_searched.limit(current_user.page_size).offset(start)
    else
      items_searched = @items
      items_offset = items_searched[start.to_i...start.to_i+current_user.page_size]
    end

    options[:total_results] = items_searched.count
    options[:collection] ||= items_offset

    if options[:list_partial]
      rendered_html = render_to_string(:partial=>options[:list_partial], :locals=>options)
    else
      rendered_html = render_to_string(:partial=>"common/tupane_list_items", :locals=>options)
    end

    render :json => {:html => rendered_html,
      :results_count => options[:total_count],
      :total_items => options[:total_results],
      :current_items => options[:collection].length }

    # TODO: user saved search history
    #retain_search_history
  end

=begin
  def retain_search_history
    # save the request in the user's search history
    unless params[:search].nil? or params[:search].blank?
      path = URI(@_request.env['HTTP_REFERER']).path
      histories = current_user.search_histories.where(:path => path, :params => params[:search])
      if histories.nil? or histories.empty?
        # user doesn't have this search stored, so save it
        histories = current_user.search_histories.create!(:path => path, :params => params[:search])
      else
        # user already has this search in their history, so just update the timestamp, so that it shows as most recent
        histories.first.update_attribute(:updated_at, Time.now)
      end
    end
  rescue => error
    log_exception(error)
  end
=end

  def render_tupane_view(collection, options)
    options[:accessor] ||= "id"
    options[:left_panel_width] ||= nil
    options[:ajax_load] ||= false
    enable_create = options[:enable_create]
    enable_create = true if enable_create.nil?
    enable_sort = options[:enable_sort] ? options[:enable_sort] : false

    raise ":titles option not provided" unless options[:titles]

    render :partial => "common/tupane",
      :locals => {
        :title => options[:title],
        :name => options[:name],
        :create => options[:create],
        :enable_create => enable_create,
        :create_label => options[:create_label] || nil,
        :enable_sort => enable_sort,
        :columns => options[:columns],
        :titles => options[:titles],
        :custom_rows => options[:custom_rows],
        :collection => collection,
        :accessor=>options[:accessor],
        :url=>options[:url],
        :left_panel_width=>options[:left_panel_width],
        :ajax_load => options[:ajax_load],
        :ajax_scroll =>options[:ajax_scroll],
        :search_env =>options[:search_env],
        :initial_action=>options[:initial_action] || :edit,
        :initial_state=>options[:initial_state] || false,
        :actions=>options[:actions],
        :search_class=>options[:search_class],
        :disable_create=>options[:disable_create] || false
    }

  end

end
