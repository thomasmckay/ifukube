task :reindex do

  Tire.index("_all").delete

  model_list = ['IndexedModel', 'Ticket', 'User']

  Dir.glob('./app/models/*.rb').each { |file| require file }
  models = ActiveRecord::Base.subclasses.sort{|a,b| a.name <=> b.name}
  models.each{|mod|
    if model_list.include?(mod.name) && mod.respond_to?(:index)
       print "Re-indexing #{mod}\n"
       mod.index.import(mod.all) if mod.count > 0
    end
  }

end