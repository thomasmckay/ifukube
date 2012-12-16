if Rails.env.development?
  Tire.configure do
    url 'http://localhost:9200'
    logger "#{Rails.root}/log/elasticsearch.log", level: 'debug'
  end
elsif Rails.env.production?
  Tire.configure do
    url 'http://butterflysearch-thomasmckay.rhcloud.com:80'
    logger "#{Rails.root}/log/elasticsearch.log"
  end
end
