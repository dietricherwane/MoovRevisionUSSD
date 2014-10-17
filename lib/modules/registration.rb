module Registration
  
  # Choose subscription period
  def self.subscription_selection(screen_id)
    return xml_skeleton("menu", "Période de souscription:", [["1", "Jour"], ["2", "Semaine"], ["3", "Mois"]], 0, "continue", screen_id)
  end
  
  def self.question_type_selection(screen_id)
    return xml_skeleton("menu", "Choix du questionnaire:", [["1", "Révision scolaire"], ["2", "Culture générale"]], 1, "continue", screen_id)
  end
  
  def self.select_academic_level(screen_id)
    return xml_skeleton("menu", "Niveau scolaire:", [["1", "6ème"], ["2", "5ème"], ["3", "4ème"], ["4", "3ème"], ["5", "2nde"], ["6", "1ère"], ["7", "Tle"]], 1, "continue", screen_id)
  end
  
  def self.confirm_registration(session, screen_id)
    question_type = session.question_type
    subscription = session.subscription
    return xml_skeleton("menu", "Vous avez opté pour MOOV REVISION - #{question_type.name}#{session.academic_level ? ' niveau: ' + session.academic_level.name : ''}. Vous serez débité de #{subscription.price} FCFA. Inscription valable pour #{subscription.duration} jour#{(subscription.duration > 1) ? 's' : ''}", [["1", "Confirmer"], ["2", "Annuler"]], 1, "continue", screen_id)
  end
  
  def self.validate_registration(screen_id)
    return xml_skeleton("form", "Bienvenue au jeu MOOV REVISION. Votre inscription a bien été prise en compte. Répondez aux questions, cumulez le maximum de points et gagnez de nombreux lots.", [], 0, "end", screen_id)
  end
  
  def self.cancel_registration(screen_id)
    return xml_skeleton("form", "Vous avez annulé votre souscription au jeu MOOV REVISION. Répondez aux questions, cumulez le maximum de points et gagnez de nombreux lots.", [], 0, "end", screen_id)
  end
  
  def self.xml_skeleton(screen_type, text, menu_options, back_link, session_op, screen_id)
    #text = URI.escape(text)
    text = text.force_encoding("utf-8")
    unless menu_options.blank?
      my_menu = get_menu(menu_options)
    end
    
    return "<?xml version='1.0' encoding='utf-8'?>
    <response>
      <screen_type>#{screen_type}</screen_type>
      <text>#{text}</text>
      #{my_menu}
      <back_link>#{back_link}</back_link>
      <home_link>0</home_link>
      <session_op>#{session_op}</session_op>
      <screen_id>#{screen_id}</screen_id>
    </response>
    "
  end
  
  def self.get_menu(menu_options)
    my_menu = "<options>"
    menu_options.each do |menu_option|
      my_menu << "<option choice = '#{menu_option[0]}'>#{menu_option[1]}</option>"
    end
    my_menu << "</options>"
  end

end
