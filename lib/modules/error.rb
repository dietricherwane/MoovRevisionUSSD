module Error
  
  def self.parameters_uninitialized(screen_id)
    return xml_skeleton("MOOV REVISION\n\nLes paramètres de la requête sont incomplets.", screen_id)
  end
  
  def self.session_expired(screen_id)
    return xml_skeleton("MOOV REVISION\n\nVotre session a expiré. Veuillez réessayer", screen_id)
  end
  
  def self.invalid_subscription_period(screen_id)
    return xml_skeleton("MOOV REVISION\n\nLa période de souscription choisie ne fait pas partie de la liste.", screen_id)
  end
  
  def self.invalid_question_type(screen_id)
    return xml_skeleton("MOOV REVISION\n\nLe questionnaire choisi ne fait pas partie de la liste.", screen_id)
  end
  
  def self.invalid_academic_level_choice(screen_id)
    return xml_skeleton("MOOV REVISION\n\nLe niveau académique choisi ne choisi ne fait pas partie de la liste.", screen_id)
  end
  
  def self.invalid_registration_validation_choice(screen_id)
    return xml_skeleton("MOOV REVISION\n\nLa réponse choisie ne fait pas partie de la liste.", screen_id)
  end
  
  def self.timeout(screen_id)
    return xml_skeleton("MOOV REVISION-1\n\nVeuillez réessayer plus tard.", screen_id)
  end
  
  def self.no_http_response(screen_id)
    return xml_skeleton("MOOV REVISION-2\n\nVeuillez réessayer plus tard.", screen_id)
  end 
  
  def self.non_successful_http_response(screen_id)
    return xml_skeleton("MOOV REVISION-3\n\nVeuillez réessayer plus tard.", screen_id)
  end
  
  def self.billing(screen_id)
    return xml_skeleton("MOOV REVISION-3\n\nVotre compte n'a pas pu être débité.", screen_id)
  end
  
  def self.xml_skeleton(text, screen_id)
    text = URI.escape(text)
    #text = text.force_encoding("utf-8")
    
    return "<?xml version='1.0' encoding='utf-8'?>
    <response>
      <screen_type>form</screen_type>
      <text>#{text}</text>
      <session_op>end</session_op>
      <screen_id>#{screen_id}</screen_id>
    </response>
    "
  end
  
end
