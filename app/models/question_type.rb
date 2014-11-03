class QuestionType < ActiveRecord::Base
  attr_accessible :name, :published, :ussd_id
  
  # Relationships
  has_many :academic_levels
  has_many :sessions
end
