-------------------------------
  
install.packages ("rtweet")

install.packages("ggplot2")
install.packages("tidytext")
install.packages("dplyr")
install.packages("readr")
install.packages("stringr")
install.packages("tidyr")
install.packages("scales")
install.packages("wordcloud")
install.packages("reshape2")


library (rtweet)
library(ggplot2)
library(tidytext)
library (dplyr)
library (readr)
library(stringr)
library(tidyr)
library(scales)
library(wordcloud)
library(reshape2)




#------------------------------
#Connect to Twitter API

  # whatever name you assigned to your created app
  appname <- "MariaP"
  
  ## api key (example below is not a real key)
  key <- "W6G8J2SOcOpoLnidoCeM4XIIH"
  
  
  ## api secret (example below is not a real key)
  secret <- "MHdYH2ui7cQlsXoDVk65H6gnWyqolDuyaukfJIm4Vh8Su9rnoS"
  
  #Create token named "twitter_token"
    twitter_token <- create_token(
    app = appname,
    consumer_key = key,
    consumer_secret = secret)
    
#----------------------------
  #Start working with Twitter 
  #Search tweets with hashtags
  SydneyTweets <- search_tweets(q = "Sydney", n = 1000, lang = "en", include_rts = FALSE)
  MelbourneTweets <- search_tweets(q = "Melbourne", n = 1000, lang = "en", include_rts = FALSE)
  
  # Let's see how frequenty tweets appear
  ts_plot(SydneyTweets, by="mins")
  
  #or if we want to be more fancy!
  ts_plot(SydneyTweets, "mins") +
    labs (
      x="Date and time",
      y="Frequency of tweets",
      title="Time series of #Sydney tweets"
    ) +
    theme_light()
  
  #search tweets from a user
  MelbourneCityTweets <- get_timeline("cityofmelbourne")
  SydneyCityTweets <- get_timeline("cityofsydney")
  
  #visualise frequency
  ts_plot(MelbourneCityTweets, "days")
  ts_plot(MelbourneCityTweets, "hours")
  ts_plot(SydneyCityTweets, "days")
  ts_plot(SydneyCityTweets, "hours")
  
  #Let's merge two datasets for hashtag tweets and add a label 'city' 
  tweets <- bind_rows(MelbourneTweets %>% 
                        mutate(city = "Melbourne"),
                      SydneyTweets %>% 
                        mutate(city = "Sydney")) 

  #Let's count how many times each user used the hashtag for the city
  tweets<-tweets %>% 
    add_count(user_id)

#and let's draw it
  ggplot(tweets, aes(x = user_id, y=n, color= city)) + geom_point()

  
  #---------------
  #lookup user information 
  users <- c("cityofsydney", "cityofmelbourne")
  cityTweets <- lookup_users(users)
  
  #lookup friends
  city_fds <- get_friends(users)
  
  #lookup followers
  city_flw <- get_followers("cityofsydney", n = 75000)
  
  
  #lookup data on followers' accounts
  city_flw_data <- lookup_users(city_flw$user_id)
  
  #let's work with the combined data from @cityOfMelbourne and @cityOfSydney more closely
  #i have pre-processed it, so you can just upload it here
  cityTweets<-read_csv("tutorial data/citytweets.csv") 
  
#Let's have a look at Word frequencies in tweets
  #but first we need to clean them to remove unwanted characters that Twitter specific
  #we also remove stop words, punctuation etc.
  
  remove_reg <- "&amp;|&lt;|&gt;"
  cityTweets_tidy <- cityTweets %>% 
    filter(!str_detect(text, "^RT")) %>%
    mutate(text = str_remove_all(text, remove_reg)) %>%
    unnest_tokens(word, text, token = "tweets") %>%
    filter(!word %in% stop_words$word,
           !word %in% str_remove_all(stop_words$word, "'"),
           str_detect(word, "[a-z]"))
  

#  Let's calculate frequencies of words for these two accounts
  frequency <- cityTweets_tidy %>% 
    group_by(city) %>% 
    count(word, sort = TRUE) %>% 
    left_join(cityTweets_tidy %>% 
                group_by(city) %>% 
                summarise(total = n())) %>%
    mutate(freq = n/total) 
  frequency
  
  
  frequency <- frequency %>% 
    select(city, word, freq) %>% 
    spread(city, freq) %>%
    arrange(Melbourne, Sydney)
  
  frequency
  
  #let' visualise frequencies
  #Words near the line are used with about equal frequencies by Melbourne and Sydney, 
  #while words far away from the line are used much more by one account compared to the other.
  
  ggplot(frequency, aes(Melbourne, Sydney)) +
    geom_jitter(alpha = 0.1, size = 2.5, width = 0.25, height = 0.25) +
    geom_text(aes(label = word), check_overlap = TRUE, vjust = 1.5) +
    scale_x_log10(labels = percent_format()) +
    scale_y_log10(labels = percent_format()) +
    geom_abline(color = "red")
  
  #now let's do wordclouds
  #for a merged dataset
  cityTweets_tidy %>% 
    count(word, sort = TRUE)  %>%
    with(wordcloud(word, n, max.words = 100))
  
  
  #For City of Sydney
  cityTweets_tidy %>% 
    filter(city=="Sydney")%>% 
    count(word, sort = TRUE)  %>%
    with(wordcloud(word, n, max.words = 100))
  
  #Let's get the wordcloud for positive and negative words
  cityTweets_tidy %>%
    inner_join(get_sentiments("bing")) %>%
    count(word, sentiment, sort = TRUE) %>%
    acast(word ~ sentiment, value.var = "n", fill = 0) %>%
    comparison.cloud(colors = c("gray20", "gray80"),
                     max.words = 100)
  
  
  

  
  
  
  #let's do the same for city of Melbourne and city of Sydney tweets
  citytweets <- bind_rows(MelbourneCityTweets %>% 
                            mutate(city = "Melbourne"),
                          SydneyCityTweets %>% 
                            mutate(city = "Sydney")) 
  
  
  
  
  save_as_csv(tweets, "tweets.csv")
  
    save_as_csv(citytweets, "citytweets.csv")
  
  save_as_csv(MelbourneCityTweets, "MelbourneCityTweets.csv")

  save_as_csv(MelbourneCityTweets, "SydneyCityTweets.csv")
  
  test<-read_csv("MelbourneCityTweets.csv")
  
  
library(tidytext)
library(dplyr)
library(readr)

library(lubridate)
options(stringsAsFactors = FALSE) 

tweets<-read_csv("MelbourneTweets.csv")

MelbourneTweets1<-MelbourneTweets%>%mutate(timestamp=ymd_hms(created_at))

ts_plot(MelbourneTweets, by="hours")

mutate(timestamp = ymd_hms(timestamp))



  rt <- search_tweets(
    "@Crowdcube", n = 18000, include_rts = FALSE
  )
  