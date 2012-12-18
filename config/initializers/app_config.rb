require 'ostruct'
require 'yaml'

module ApplicationConfiguration

  class Config
    include Singleton

    attr_reader :config_file

    LOG_LEVELS = ['debug', 'info', 'warn', 'error', 'fatal']

    def initialize
      @config_file = "#{Rails.root}/config/ifukube.yml"
      @config_file = "#{ENV['OPENSHIFT_DATA_DIR']}/ifukube.yml" unless File.exists? @config_file
      raise "Missing ifukube.yml config" unless File.exists? @config_file

      config = YAML::load_file(@config_file)
      @hash = config['common'] || {}
      @hash.deep_merge!(config[Rails.env] || {})

      @ostruct = hashes2ostruct(@hash)

      @ostruct.elastic_url = 'http://localhost:9200' unless @ostruct.respond_to?(:elastic_url)
      @ostruct.elastic_logging = 'info' unless @ostruct.respond_to?(:elastic_logging)

      @ostruct.simple_search_tokens = [':', ' and\\b', ' or\\b', ' not\\b'] unless @ostruct.respond_to?(:simple_search_tokens)

      #configuration is created after environment initializers, so lets override them here
      Rails.logger.level = LOG_LEVELS.index(@ostruct.log_level) if LOG_LEVELS.include?(@ostruct.log_level)
      ActiveRecord::Base.logger.level = LOG_LEVELS.index(@ostruct.log_level_sql) if LOG_LEVELS.include?(@ostruct.log_level_sql)

      # backticks gets you the equiv of a system() command in Ruby
      hash = `git rev-parse --short HEAD 2>/dev/null`
      exit_code = $?
      if exit_code != 0
        version = "Unknown"
      else
        version = "git hash (" + hash.chop + ")"
      end

      @ostruct.ifukube_version = version
    end

    # helper method that converts object to open struct recursively
    def hashes2ostruct(object)
      return case object
      when Hash
        object = object.clone
        object.each do |key, value|
          object[key] = hashes2ostruct(value)
        end
        OpenStruct.new(object)
      when Array
        object = object.clone
        object.map! { |i| hashes2ostruct(i) }
      else
        object
      end
    end

    def to_os
      @ostruct
    end

    def to_hash
      @hash
    end
  end
end

# singleton object itself (to access custom methods)
::AppConfigObject = ApplicationConfiguration::Config.instance

# config as hash structure
::AppConfigHash = ApplicationConfiguration::Config.instance.to_hash

# config as open struct
::AppConfig = ApplicationConfiguration::Config.instance.to_os

# add a default format for date... without this, rendering a datetime included "UTC" as
# of the string
Time::DATE_FORMATS[:default] = "%Y-%m-%d %H:%M:%S"
