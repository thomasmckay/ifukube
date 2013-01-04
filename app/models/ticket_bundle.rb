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
        self.metaclass.send(:define_method, "#{name}_#{ticket.id}") do |v={}|
          ticket.send(name)
        end
        self.metaclass.send(:define_method, "#{name}_#{ticket.id}=") do |v|
          ticket.send(name, v)
        end
        #send("#{name}_#{ticket.id}=", ticket.send(name))
      end
    end
  end

  def persisted?
    false
  end

=begin
  def state_6
    return 'NEW'
  end

  def state_4
    return 'POST'
  end

  def state_6= v
    return 'NEW'
  end

  def state_4= v
    return 'POST'
  end
=end

=begin
  @_tickets = []

  def tickets=(tickets)
    @_tickets = tickets
  end

  def tickets
    @_tickets
  end

  def state
    x = 1
  end
=end

end
