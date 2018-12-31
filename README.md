Exploring social media analytics with R
================
[Maria Prokofieva](https://github.com/mariaprokofieva)
02/12/2018

Social media analytics (SMA) is a powerful tool that offer wide opportunities for academics and industry professionals. SMA relates to a number of tools to collect data from digital media platforms, process it into structured insights and assist in more information-driven decision making. The tutorial introduces SMA with R.

### Topics covered during the tutorial include:

-   Benefits and challenges working with social media data (textual/non-textual information, large data volume, API access)

-   Structure of the social media data (e.g. user-related data, posting related data, hashtags)

-   Connecting to a social media platform (e.g. authentication) and downloading data

\[Setting up API access for Twitter\] (\# setup-API)

[Connecting to Twitter from R](#connect)

\[Downloading tweets with `twitterR`\] (\# downloading-tweets)

-   Data analysis of the profile information (e.g. followers, likes, dislikes, favorites - platform dependent) \[Analyse tweets\] (\# analyse-tweets)

-   Data analysis of textual information and non-textual (e.g. user posts, comments, dynamics, sentiment analysis, word clouds, etc.) \[Analyse text tweets\] (\# analyse-text)

-   Visualisation of the social media data

------------------------------------------------------------------------

### Resource:

-   \[Packages to be used - please install\]

``` r
> install.packages ("rtweet")
> 
> install.packages("ggplot2")
> install.packages("tidytext")
> install.packages("dplyr")
> install.packages("readr")
> install.packages("stringr")
> install.packages("tidyr")
> install.packages("scales")
> install.packages("wordcloud")
> install.packages("reshape2")
```

-   Reference material

[Setting up the Twitter R package for text analytics](https://www.r-bloggers.com/setting-up-the-twitter-r-package-for-text-analytics/)

[Setting API for rtweet](https://rtweet.info/articles/auth.html)

------------------------------------------------------------------------

-   R and RStudio installation

R is a free software environment for data analysis and visualisation. It runs on a variety of platforms, including Windows and MacOS. You can download R for your computer

[for Windows](https://cran.r-project.org/bin/windows/base/)

[for MacOS](https://cran.r-project.org/bin/windows/base/)

Once R is installed, please install RStudio [here](https://www.rstudio.com/products/rstudio/download/) - use RStudio Desktop Open Source License

The installation is very straightforward, but you can also have a look at these tutorials

[install RStudio for Windows](https://www.youtube.com/watch?v=Ohnk9hcxf9M)

[install RStudio for Mac](https://www.youtube.com/watch?v=uxuuWXU-7UQ)

------------------------------------------------------------------------

### Connecting to Twitter from R

Before you start working with Twitter in R, you need to setup your access in the Twitter itself. Please see [Setting up API in Twitter](twitterAPI.Rmd)

Note down:

-   Your App Name

-   Your Consumer Key (API Key)

-   Consumer Secret (API Secret)

------------------------------------------------------------------------

There are two main R packaages to work with Twitter:

-   [`rtweet`](https://cran.r-project.org/web/packages/rtweet/index.html)
-   [`twitteR`](https://cran.r-project.org/web/packages/twitteR/README.html)

In this tutorial we will be using `rtweet`

To use this package you need to install it in R first. You do it by typing the following line

``` r
> install.packages("rtweet")
```

We will also need several more packages to work with data:

``` r
> install.packages("ggplot2")
> install.packages("tidytext")
> install.packages("dplyr")
> install.packages("readr")
> install.packages("stringr")
> install.packages("tidyr")
> install.packages("scales")
> install.packages("wordcloud")
> install.packages("reshape2")
```

and then load these packages

``` r
> library (rtweet)
> library(ggplot2)
> library(tidytext)
> library (dplyr)
> library (readr)
> library(stringr)
> library(tidyr)
> library(scales)
> library(wordcloud)
> library(reshape2)
```

Now you are all ready to go!

To connect to Twitter you need to set up your access variables:

``` r
> # whatever name you assigned to your created app
> appname <- "MariaP"
> 
> ## api key (example below is not a real key)
> key <- "XXXXXXXXXX"
> 
> ## api secret (example below is not a real key)
> secret <- "YYYYYYYYYY"
```

Now let's create a token and connect!

``` r
> twitter_token <- create_token(
>   app = appname,
>   consumer_key = key,
>   consumer_secret = secret)
```

`create_token` function sends a request to generate your access token. The technical part of this is explained [here](https://developer.twitter.com/en/docs/basics/authentication/overview/oauth)

------------------------------------------------------------------------

We are all ready to go! Let's search out tweets.

`search_tweet` function is fantastic. It allow you search hashtags and user timelines. It takes the folowing arguments

``` r
> SydneyTweets <- search_tweets(q = "Sydney", n = 1000, lang = "en", include_rts = FALSE)  
> MelbourneTweets <- search_tweets(q = "Melbourne", n = 1000, lang = "en", include_rts = FALSE)
```

-   `q`: query to be searched
-   `n`: number of tweets to return. The maximum is 18,000. But you will need to do this in "batches", so need to use `retryonratelimit` argument
-   `include_rts`: if set to FALSE, retweets are excluded from the results

Let's see how frequenty tweets appear

``` r
> ts_plot(SydneyTweets, by="days")
```

<img src="tutorial images/sydney1.png" alt="Frequency of tweets with #sydney" width="787" />
<p class="caption">
Frequency of tweets with \#sydney
</p>

or if we want to be more fancy!

``` r
>   ts_plot(SydneyTweets, "mins") +
>     labs (
>       x="Date and time",
>       y="Frequency of tweets",
>       title="Time series of #Sydney tweets"
>     ) +
>     theme_dark()
```

<img src="tutorial images/sydneydark.png" alt="Adding some elements to the graph" width="787" />
<p class="caption">
Adding some elements to the graph
</p>

We can get tweets from a particular Twitter account using `get_timeline`

``` r
>   MelbourneCityTweets <- get_timeline("cityofmelbourne")
>   SydneyCityTweets <- get_timeline("cityofsydney")
```

Let's visualise their frequencies

``` r
>   ts_plot(MelbourneCityTweets, "days")
>   ts_plot(MelbourneCityTweets, "hours")
>   ts_plot(SydneyCityTweets, "days")
>   ts_plot(SydneyCityTweets, "hours")
```

<img src="tutorial images/melbournedays2.png" alt="Frequencies of @CityOfMelbourne tweet, days" width="787" />
<p class="caption">
Frequencies of @CityOfMelbourne tweet, days
</p>

<img src="tutorial images/melbournehours.png" alt="Frequencies of @CityOfMelbourne tweet, hours" width="787" />
<p class="caption">
Frequencies of @CityOfMelbourne tweet, hours
</p>

Let's merge two datasets for hashtag tweets and add a label 'city'

``` r
>   tweets <- bind_rows(MelbourneTweets %>% 
>                         mutate(city = "Melbourne"),
>                       SydneyTweets %>% 
>                         mutate(city = "Sydney")) 
```

Let's count how many times each user used the hashtag for the city

``` r
>   tweets<-tweets %>% 
+     add_count(user_id)
> kable(tweets[5:10, 3:6])
```

| created\_at         | screen\_name   | text                                                                                                                                                                                                                                                                                                       | source             |
|:--------------------|:---------------|:-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|:-------------------|
| 2018-12-02 22:48:14 | SBEAustralia   | Interested in scaling your business as a \#womenintech & \#womeninSTEM? Don't miss out on our upcoming event in \#Melbourne on 11 Dec at \#telstralabs with alum Anabela Correia, Kathy Harrison, @AlisonHardacre & @AyalaDomani of @Telstra RSVP now: <https://t.co/Vo4MWPlyIB> <https://t.co/BbhGgoonxi> | Twitter Web Client |
| 2018-12-02 22:48:12 | beatthatflight | Aussie flight deal: Possible business class error fare! Singapore to Sydney/Melbourne/Perth on Qantas from <https://t.co/AWbqSIHKTN> \#travel                                                                                                                                                              | Beat That Flight   |
| 2018-12-02 14:52:55 | beatthatflight | Aussie flight deal: Sydney/Melbourne to Honolulu, Hawaii from $495/ $511 Return on Jetstar <https://t.co/yrnqzuKRS8> \#travel                                                                                                                                                                              | Beat That Flight   |
| 2018-12-02 22:48:09 | ibmlgbt        | IBM was honored to welcome Guide Dogs Victoria to our \#AccessAbilityDay afternoon tea in Melbourne                                                                                                                                                                                                        |                    |
| \#inclusiveIBM      |                | Twitter Web Client                                                                                                                                                                                                                                                                                         |                    |
| 2018-12-02 22:47:23 | LukusWilson    | @itshannahbowman so you mean melbourne right?                                                                                                                                                                                                                                                              | Twitter for iPhone |
| 2018-12-02 22:47:09 | ANZStadium     | PRAYERS answered: It's @BonJovi week, Sydney! Get in the mood for Saturday by reading this review of their show in Melbourne on Saturday: <https://t.co/YHUdxbUIhi> \#ThisHouseIsNotForSale <https://t.co/VfmQFKbCvj>                                                                                      | Twitter Web Client |

and let's draw it

``` r
>   ggplot(tweets, aes(x = user_id, y=n, color= city)) + geom_point()
```

<img src="README_figs/README-unnamed-chunk-21-1.png" style="display: block; margin: auto;" />

------------------------------------------------------------------------

You can also search Twitter user data using `lookup_users`:

``` r
> users <- c("cityofsydney", "cityofmelbourne")
> cityTweets <- lookup_users(users)
```

``` r
> kable(cityTweets[5:10, 3:6])
```

| created\_at              | screen\_name         | text                                                                                                                                                                                                                                                        | source             |
|:-------------------------|:---------------------|:------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|:-------------------|
| 2018-12-03 00:39:26      | cityofmelbourne      | This morning Cr @BeverleyPinder launched the 2018 Victorian Disability Sport and Recreation Festival at Southbank’s Crown Riverwalk. Head down to explore and experience accessible and inclusive sport. It’s on from 10am - 3pm. <https://t.co/KHfYkwqXCH> | Twitter for iPhone |
| 2018-12-02 20:25:07      | cityofmelbourne      | Jane Harper dreamed up some of her first novel at City Library. Now she's hit the big time.                                                                                                                                                                 |                    |
| <https://t.co/v2jlr2VxW> | H <https://t.co/T2T> | JWP86is Hootsuite Inc.                                                                                                                                                                                                                                      |                    |
| 2018-12-01 03:28:15      | cityofmelbourne      | Celebrating A Very Koorie Krismas @FedSquare <https://t.co/jiVdIxnfe8>                                                                                                                                                                                      | Twitter for iPhone |
| 2018-12-01 01:40:06      | cityofmelbourne      | Get a taste of Christmas, the Gingerbread Village has opened at Federation Square                                                                                                                                                                           |                    |
| <https://t.co/wnNc0u30d> | 1 <https://t.co/oO2> | mJUx8Ga Hootsuite Inc.                                                                                                                                                                                                                                      |                    |
| 2018-11-30 23:35:07      | cityofmelbourne      | Sing and splash, bust a rhyme or kick back with cool tunes at our pools this summer. <https://t.co/uJ434t96El> <https://t.co/z2COQsagXu>                                                                                                                    | Hootsuite Inc.     |
| 2018-11-30 10:41:32      | cityofmelbourne      | Federation Square is LIT. Thanks to everyone who came and celebrated the lighting of the Christmas tree.                                                                                                                                                    |                    |

Make sure you check out our Christmas events. <https://t.co/wnNc0ukB4z> <https://t.co/sHhZGrD6Ou> Twitter for iPhone

Lookup friends

``` r
>   city_fds <- get_friends(users)
```

Lookup followers

``` r
>   city_flw <- get_followers("cityofsydney", n = 75000)
```

Lookup data on followers' accounts

`r  >  city_flw_data <- lookup_users(city_flw$user_id)`

Let's have a look at Word frequencies in tweets, but first we need to clean them to remove unwanted characters that Twitter specific, we also remove stop words, punctuation etc.

``` r
> remove_reg <- "&amp;|&lt;|&gt;"
>   cityTweets_tidy <- cityTweets %>% 
+     filter(!str_detect(text, "^RT")) %>%
+     mutate(text = str_remove_all(text, remove_reg)) %>%
+     unnest_tokens(word, text, token = "tweets") %>%
+     filter(!word %in% stop_words$word,
+            !word %in% str_remove_all(stop_words$word, "'"),
+            str_detect(word, "[a-z]"))
```

Calculate frequencies of words for these two accounts

``` r
>   frequency <- cityTweets_tidy %>% 
+     group_by(city) %>% 
+     count(word, sort = TRUE) %>% 
+     left_join(cityTweets_tidy %>% 
+                 group_by(city) %>% 
+                 summarise(total = n())) %>%
+     mutate(freq = n/total) 
>   frequency
```

    ## # A tibble: 1,765 x 5
    ## # Groups:   city [2]
    ##    city      word          n total    freq
    ##    <chr>     <chr>     <int> <int>   <dbl>
    ##  1 Sydney    city         33  1475 0.0224 
    ##  2 Sydney    sydney       28  1475 0.0190 
    ##  3 Melbourne city         16  1198 0.0134 
    ##  4 Melbourne melbourne    13  1198 0.0109 
    ##  5 Sydney    ref          12  1475 0.00814
    ##  6 Melbourne christmas    11  1198 0.00918
    ##  7 Sydney    christmas    11  1475 0.00746
    ##  8 Sydney    nsw          11  1475 0.00746
    ##  9 Sydney    team         11  1475 0.00746
    ## 10 Sydney    transport    10  1475 0.00678
    ## # ... with 1,755 more rows

Let's make the table more readable

``` r
>   frequency <- frequency %>% 
+     select(city, word, freq) %>% 
+     spread(city, freq) %>%
+     arrange(Melbourne, Sydney)
>   
>   frequency
```

    ## # A tibble: 1,593 x 3
    ##    word       Melbourne   Sydney
    ##    <chr>          <dbl>    <dbl>
    ##  1 access      0.000835 0.000678
    ##  2 activated   0.000835 0.000678
    ##  3 australian  0.000835 0.000678
    ##  4 awards      0.000835 0.000678
    ##  5 beautiful   0.000835 0.000678
    ##  6 beginning   0.000835 0.000678
    ##  7 begins      0.000835 0.000678
    ##  8 bins        0.000835 0.000678
    ##  9 care        0.000835 0.000678
    ## 10 catch       0.000835 0.000678
    ## # ... with 1,583 more rows

Let's visualise frequencies

Words near the line are used with about equal frequencies by Melbourne and Sydney, while words far away from the line are used much more by one account compared to the other.

``` r
>   ggplot(frequency, aes(Melbourne, Sydney)) +
+     geom_jitter(alpha = 0.1, size = 2.5, width = 0.25, height = 0.25) +
+     geom_text(aes(label = word), check_overlap = TRUE, vjust = 1.5) +
+     scale_x_log10(labels = percent_format()) +
+     scale_y_log10(labels = percent_format()) +
+     geom_abline(color = "red")
```

<img src="README_figs/README-unnamed-chunk-31-1.png" style="display: block; margin: auto;" />

Now let's do wordclouds for a merged dataset

``` r
>   cityTweets_tidy %>% 
+     count(word, sort = TRUE)  %>%
+     with(wordcloud(word, n, max.words = 100))
```

<img src="README_figs/README-unnamed-chunk-32-1.png" style="display: block; margin: auto;" />

and for @cityofSydney

``` r
>   cityTweets_tidy %>% 
+     filter(city=="Sydney")%>% 
+     count(word, sort = TRUE)  %>%
+     with(wordcloud(word, n, max.words = 100))
```

<img src="README_figs/README-unnamed-chunk-33-1.png" style="display: block; margin: auto;" />

Let's get the wordcloud for positive and negative words

``` r
>   cityTweets_tidy %>%
+     inner_join(get_sentiments("bing")) %>%
+     count(word, sentiment, sort = TRUE) %>%
+     acast(word ~ sentiment, value.var = "n", fill = 0) %>%
+     comparison.cloud(colors = c("gray20", "gray80"),
+                      max.words = 100)
```

<img src="README_figs/README-unnamed-chunk-34-1.png" style="display: block; margin: auto;" />
