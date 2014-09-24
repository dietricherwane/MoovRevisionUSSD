class Session < ActiveRecord::Base
  attr_accessible :msisdn, :sc, :session_id, :req_no, :subscription_id, :question_type_id, :academic_level_id, :user_input
  
  # Relationships
  belongs_to :question_type
  belongs_to :subscription
  belongs_to :academic_level
end
