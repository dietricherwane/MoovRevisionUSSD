class Subscription < ActiveRecord::Base
  attr_accessible :name, :duration, :price, :published, :ussd_id
  
  # Relationships
  has_many :sessions
end
