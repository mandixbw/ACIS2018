-------------------------------
  
  # whatever name you assigned to your created app
  appname <- "MariaP"
  
  ## api key (example below is not a real key)
  key <- "W6G8J2SOcOpoLnidoCeM4XIIH"
  
  ## api secret (example below is not a real key)
  secret <- "MHdYH2ui7cQlsXoDVk65H6gnWyqolDuyaukfJIm4Vh8Su9rnoS"
  
  # create token named "twitter_token"
  twitter_token <- create_token(
    app = appname,
    consumer_key = key,
    consumer_secret = secret)
  
  SydneyTweets <- search_tweets(q = "Sydney", n = 1000, lang = "en")
  MelbourneTweets <- search_tweets(q = "Melbourne", n = 1000, lang = "en")
  

  save_as_csv(SydneyTweets, "SydneyTweets.csv")
  save_as_csv(MelbourneTweets, "MelbourneTweets.csv")
  
  test<-read.csv("MelbourneTweets.csv")
  
  rt <- search_tweets(
    "@Crowdcube", n = 18000, include_rts = FALSE
  )
  