module MachineLearningConstants

  SYNCHRONOUS_MACHINE_LEARNING_SERVICES = [:calais]
  ASYNCHRONOUS_MACHINE_LEARNING_SERVICES = [:google_prediction, 
    :google_prediction_train, :google_prediction_check_training, 
    :google_prediction_predict]
  MACHINE_LEARNING_SERVICES = SYNCHRONOUS_MACHINE_LEARNING_SERVICES + ASYNCHRONOUS_MACHINE_LEARNING_SERVICES

  #Calais only allows 4 requests per second, and if we do more than that,
  #it's slower than if we limited the requests on our end.
  #Each request takes about 2 seconds, so 8 threads should allow 4 requests
  #per second
  NUM_CALAIS_THREADS = 8
end

