
Tire.configure do
  url AppConfig.elastic_url
  logger "#{Rails.root}/log/elasticsearch.log", :level => AppConfig.elastic_logging
end
