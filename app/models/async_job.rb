class AsyncJob < ActiveRecord::Base
  attr_accessible :sidekiq

  belongs_to :user
  belongs_to :bugzilla_bug

end
