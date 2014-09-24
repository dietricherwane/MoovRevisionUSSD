class SessionsController < ApplicationController

  def index
    if params_initialized(params)
      #S'assurer que le compte n'existe pas ou n'a pas d'abonnement en cours
      if @req_no == 1
        initialize_session
      else
        select_session
        if @session
          case @req_no
            when 2
              select_subscription_period  
            when 3
              select_question_type
            end
          # @req_no = 5 when scholar knowledge question type is selected
          if general_knowledge_question_type || @req_no == 5
            validate_registration
          end
          if scholar_knowledge_question_type
            store_academic_level
          end
        else
          @response = Error.session_expired
        end
      end
    else
      @response = Error.parameters_uninitialized
    end
    
    send_response
  end  
  
  #private
  # Check initialization of request parameters
  def params_initialized(params)
    if params[:sc].blank? || invalid_msisdn(params[:msisdn]) || params[:req_no].blank? || params[:session_id].blank? || invalid_user_input_or_req_no(params[:user_input], params[:req_no])
      false
    else
      # Set class variables
      @sc = params[:sc]
      @msisdn = params[:msisdn]
      @user_input = params[:user_input].to_i
      @session_id = params[:session_id]
      @req_no = params[:req_no].to_i     
      true
    end   
  end
  
  # Check if the msisdn is invalid
  def invalid_msisdn(msisdn)
    (msisdn.blank? || msisdn.length.between?(8, 13)) ? false : true
  end
  
  # Check if the user input or the request number is invalid
  def invalid_user_input_or_req_no(user_input, req_no)
    ((user_input.blank? || not_a_number(user_input)) && (not_a_number(req_no) || req_no.to_i != 1)) ? true : false
  end
  
  # When req_no == 1
  def initialize_session
    Session.create(sc: @sc, msisdn: @msisdn, session_id: @session_id, req_no: @req_no)
    @response = Registration.subscription_selection
  end
  
  # Select an existing session and sets the correct req_no
  def select_session
    @session = Session.find_by_session_id(@session_id)
    @session = @session.last rescue @session 
    set_req_no     
  end
  
  # Sets the correct req_no to match a value, either 2, 3, 4
  def set_req_no
    if @user_input == 0
      val = 0
    else
      # If the last value entered was 0
      @session.user_input == 0 ? val =  0 : val =  1 rescue nil
    end
    @req_no = (@session.req_no + val) rescue 1
  end
  
  # Select the subscription period
  def select_subscription_period
    set_user_input
    if @user_input == 0
      @session.update_attributes(subscription_id: nil)
      @response = Registration.subscription_selection
    else
      @subscription = Subscription.find_by_ussd_id(@user_input)
      if @subscription
        @session.update_attributes(subscription_id: @subscription.id, req_no: @req_no)
        @response = Registration.question_type_selection
      else
        @response = Error.invalid_subscription_period
      end
    end
  end
  
  # Select the question type. If scholar is selected, one more selection will be added to the process
  def select_question_type
    set_user_input
    if @user_input == 0      
      @response = Registration.question_type_selection
      @session.update_attributes(question_type_id: nil, req_no: @req_no - 1)
    else
      @question_type = QuestionType.find_by_ussd_id(@user_input)
      if @question_type
        @session.update_attributes(question_type_id: @question_type.id, req_no: @req_no)
        if URI.escape(@question_type.name) == URI.escape("Révision scolaire")
          @response = Registration.select_academic_level
        else       
          @response = Registration.confirm_registration(@session)
        end
      else
        @response = Error.invalid_question_type
      end
    end
  end
  
  # Si l'abonné a choisit des questions d'ordre général
  def general_knowledge_question_type
    (@req_no == 4 && (URI.escape(@session.question_type.name) == URI.escape("Culture générale"))) ? true : false
  end
  
  # Si l'abonné a choisit des questions d'ordre scolaire
  def scholar_knowledge_question_type
    (@req_no == 4 && (URI.escape(@session.question_type.name) == URI.escape("Révision scolaire"))) ? true : false
  end
  
  def store_academic_level
    set_user_input
    if @user_input == 0 
      @session.update_attributes(academic_level_id: nil, req_no: @req_no - 1)
      @response = Registration.select_academic_level
    else
      @academic_level = AcademicLevel.find_by_ussd_id(@user_input)
      if @academic_level
        @session.update_attributes(academic_level_id: @academic_level.id, req_no: @req_no)
        @response = Registration.confirm_registration(@session)
      else
        @response = Error.invalid_academic_level_choice
      end
    end
  end
  
  def validate_registration
    set_user_input
    case @user_input
      when 1
        # Billing
        billing
        if user_billed
          create_account 
          #if account_created             
            #send first question
          #end
        else
          @response = Error.billing
        end
      when 2
        @response = Registration.cancel_registration
      else
        @response = Error.invalid_registration_validation_choice
      end
  end
  
  def set_user_input
    @session.update_attributes(user_input: @user_input)
  end
  
  def create_account
    parameter = Parameter.first
    request = Typhoeus::Request.new(parameter.sms_gateway_url, followlocation: true, method: :post, params: {msisdn: @session.msisdn, subscription_id: @session.subscription_id, question_type_id: @session.question_type_id, academic_level_id: @session.academic_level_id, session_id: @session.session_id})

    request.on_complete do |response|
      if response.success?
        @response = response.body
        #@response = Registration.validate_registration  
      elsif response.timed_out?
        @response = Error.timeout
      elsif response.code == 0
        @response = Error.no_http_response
      else
        @response = Error.non_successful_http_response
        @response = response.body
      end
    end

    request.run
  end
  
  # Checks if the account have been succesfully created after notifying the sms_gateway
  def account_created
    @response == URI.escape(Registration.validate_registration) ? true : false
  end
  
  # Bill customer from moov billing platform
  def billing
    user_agent = request.env['HTTP_USER_AGENT']
    billing_request_body = Billing.request_body(@session)
    parameter = Parameter.first
    
    request = Typhoeus::Request.new(parameter.billing_url, followlocation: true, body: billing_request_body, headers: {Accept: "text/xml", :'Content-length' => billing_request_body.bytesize, Authorization: "Basic base64_encode('NGSER-MR2014:NGSER-MR2014')", :'User-Agent' => user_agent})

#=begin
    request.on_complete do |response|
      if response.success?
        result = response.body  
      elsif response.timed_out?
        result = Error.timeout
      elsif response.code == 0
        result = Error.no_http_response
      else
        result = Error.non_successful_http_response
      end
    end

    request.run
#=end

    @xml = Nokogiri.XML(result).xpath('//methodResponse//params//param//value//struct//member')
    #render text: Billing.response_body.bytesize
  end
  
  # Check if the user have been billed after the return from Moov platform
  def user_billed
    if @xml.blank?
      return false
    else
      @xml.each do |result|
        if result.xpath("name").text.strip == "responseCode"
          if result.xpath("value").text.strip == "0"
            return true
          end
        end
      end
    end
  end
  
end
