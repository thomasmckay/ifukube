class TicketBundle
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  def metaclass
    class << self; self; end
  end

  def initialize(tickets)
    attributes = ['state', 'severity']

    tickets.each do |ticket|
      attributes.each do |name|
        self.metaclass.send(:define_method, "#{name}_#{ticket.number}") do |v={}|
          ticket.send(name)
        end
        self.metaclass.send(:define_method, "#{name}_#{ticket.number}=") do |v|
          ticket.send(name, v)
        end
        #send("#{name}_#{ticket.id}=", ticket.send(name))
      end
    end
  end

  def persisted?
    false
  end

end
