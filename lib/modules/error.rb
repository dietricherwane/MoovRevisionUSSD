module Error
  
  def self.parameters_uninitialized
    return "text=MOOV REVISION\n\nLes paramètres de la requête sont incomplets.&op=end"
  end
  
  def self.session_expired
    return "text=MOOV REVISION\n\nVotre session a expiré. Veuillez réessayer.&op=end"
  end
  
  def self.invalid_subscription_period
    return "text=MOOV REVISION\n\nLa période de souscription choisie ne fait pas partie de la liste.&op=end"
  end
  
  def self.invalid_question_type
    return "text=MOOV REVISION\n\nLe questionnaire choisi ne fait pas partie de la liste.&op=end"
  end
  
  def self.invalid_academic_level_choice
    return "text=MOOV REVISION\n\nLe niveau académique choisi ne choisi ne fait pas partie de la liste.&op=end"
  end
  
  def self.invalid_registration_validation_choice
    return "text=MOOV REVISION\n\nLa réponse choisie ne fait pas partie de la liste.&op=end"
  end
  
  def self.timeout
    return "text=MOOV REVISION-1\n\nVeuillez réessayer plus tard.&op=end"
  end
  
  def self.no_http_response
    return "text=MOOV REVISION-2\n\nVeuillez réessayer plus tard.&op=end"
  end 
  
  def self.non_successful_http_response
    return "text=MOOV REVISION-3\n\nVeuillez réessayer plus tard.&op=end"
  end
  
  def self.billing
    return "text=MOOV REVISION-3\n\nVotre compte n'a pas pu être débité.&op=end"
  end
  
end
