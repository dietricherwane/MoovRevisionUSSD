module Registration
  
  # Choose subscription period
  def self.subscription_selection
    return "text=Période de souscription:\n1. Jour\n2. Semaine\n3. Mois&op=continue"
  end
  
  def self.question_type_selection
    return "text=Choix du questionnaire:\n1. Révision scolaire\n2.\n 0. Retour Culture générale&op=continue"
  end
  
  def self.select_academic_level
    return "text=Niveau scolaire:\n1. 6ème\n2. 5ème\n3. 4ème\n4. 3ème\n5. 2nde\n6. 1ère\n7. Tle.\n0. Retour&op=continue"
  end
  
  def self.confirm_registration(session)
    question_type = session.question_type
    subscription = session.subscription
    return "text=Vous avez opté pour MOOV REVISION - #{question_type.name}#{session.academic_level ? ' niveau: ' + session.academic_level.name : ''}. Vous serez débité de #{subscription.price} FCFA. Inscription valable pour #{subscription.duration} jour#{(subscription.duration > 1) ? 's' : ''}\n1. Confirmer\n2. Annuler.\n0. Retour&op=continue"
  end
  
  def self.validate_registration
    return "text=Bienvenue au jeu MOOV REVISION. Votre inscription a bien été prise en compte. Répondez aux questions, cumulez le maximum de points et gagnez de nombreux lots.&op=end"
  end
  
  def self.cancel_registration
    return "text=Vous avez annulé votre souscription au jeu MOOV REVISION. Répondez aux questions, cumulez le maximum de points et gagnez de nombreux lots.&op=end"
  end

end
