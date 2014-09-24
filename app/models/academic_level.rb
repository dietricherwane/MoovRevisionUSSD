class AcademicLevel < ActiveRecord::Base
  attr_accessible :name, :question_type_id, :published, :ussd_id
  
  # Relationships
  belongs_to :question_type
  has_many :sessions
end
