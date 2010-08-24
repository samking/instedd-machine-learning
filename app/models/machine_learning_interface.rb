class MachineLearningInterface

  include MachineLearningConstants

  def initialize(database_table)
    @database_table = database_table
  end

  def self.make_calais_request(content, type, function_call)
    response = Calais.method(function_call).call(:content => content, 
                                      :content_type => type, 
                                      :license_id => $user_config[:calais_key]
                                     ) do |curl_client|
      #the Calais class makes a call to Curb's version of libcurl, which, by
      #default, sends an "Expect: 100" on any posts longer than 1024 bytes.
      #This block ensures that the Calais Client already has that code disabled
      #by giving the Calais Client a Curl instance with that header disabled.
      curl_client.instance_eval do 
        @client = Curl::Easy.new
        @client.headers["Expect"] = ''
      end
    end
  end

  def self.learn_from_calais(rows, type=:html, function_call=:enlighten)
      rows = [rows] if not rows.respond_to? :pmap #assumes that there is one element

      #calais doesn't have an API for batch processing, so in order to run a
      #request on each element, we want to run them in parallel
      rows.pmap([NUM_CALAIS_THREADS, rows.length].min) do |row| 
          make_calais_request(row, type, function_call)
      end
  end

  def self.supports_ml_service?(service)
    service = service.to_sym
    MACHINE_LEARNING_SERVICES.include?(service)
  end

  def make_google_predictor(filename)
    GooglePrediction.new($user_config[:google_prediction_auth_token],@database_table.bucket_name, filename)
  end

  def train_google_prediction(filename)
    make_google_predictor(filename).train
  end

  def check_training_google_prediction(filename)
    make_google_predictor(filename).check_training
  end

  def predict_google_prediction(filename, query)
    make_google_predictor(filename).predict(query)
  end

  def learn(service, learning_data_location, query)
    service = service.to_sym
    raise "Must have a row to learn on" unless learning_data_location.is_a?(String)
    if service == :calais
      rows = get_rows_from_names(learning_data_location)
      MachineLearningInterface.learn_from_calais(rows)
    elsif service == :google_prediction_train
      train_google_prediction(learning_data_location)
    elsif service == :google_prediction_check_training
      check_training_google_prediction(learning_data_location)
    elsif service == :google_prediction_predict
      predict_google_prediction(learning_data_location, query)
    else
      raise "Unsupported service: #{service}"
    end
    #database_table.add_ml_response(learning_data_location, learning_response, service)
  end

end

