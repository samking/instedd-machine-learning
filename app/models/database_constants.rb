module DatabaseConstants
  SDB_MAX_NUM_CHUNKS = 256
  #the first 3 characters are the chunk identifier, and SDB can only 
  #take 1023 bytes per chunk
  SDB_CHUNK_IDENTIFIER_SIZE = 3
  SDB_MAX_CHUNK_SIZE = 1023 - SDB_CHUNK_IDENTIFIER_SIZE
end

