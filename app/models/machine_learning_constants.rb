module MachineLearningConstants
  #TODO: support other machine learning services and put the machine learning interface into a class
  MACHINE_LEARNING_SERVICES = [:calais]

  #Calais only allows 4 requests per second, and if we do more than that,
  #it's slower than if we limited the requests on our end.
  #Each request takes about 2 seconds, so 8 threads should allow 4 requests
  #per second
  NUM_CALAIS_THREADS = 8
end

