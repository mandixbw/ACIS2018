Exploring social media analytics with R
================
[Maria Prokofivea](https://github.com/mariaprokofieva)
02/12/2018

Social media analytics (SMA) is a powerful tool that offer wide opportunities for academics and industry professionals. SMA relates to a number of tools to collect data from digital media platforms, process it into structured insights and assist in more information-driven decision making. The tutorial introduces SMA with R.

Topics covered during the tutorial include:
-------------------------------------------

-   Benefits and challenges working with social media data (textual/non-textual information, large data volume, API access)

-   Structure of the social media data (e.g. user-related data, posting related data, hashtags)

-   Connecting to a social media platform (e.g. authentication) and downloading data
-   \[Setting up API access for Twitter\] (\# setup-API)
-   \[Downloading tweets with `twitterR`\] (\# downloading-tweets)

-   Data analysis of the profile information (e.g. followers, likes, dislikes, favorites - platform dependent)
-   \[Analyse tweets\] (\# analyse-tweets)

-   Data analysis of textual information and non-textual (e.g. user posts, comments, dynamics, sentiment analysis, word clouds, etc.)

-   \[Analyse text tweets\] (\# analyse-text)

-   Visualisation of the social media data

Resource:
=========

-   R and RStudio installation (\#R-install)
-   \[Packages to be used - please install\] (\# packages-to-use)
-   \[Reference material\] (\# reference-materia)

This is an R Markdown document. Markdown is a simple formatting syntax for authoring HTML, PDF, and MS Word documents. For more details on using R Markdown see <http://rmarkdown.rstudio.com>.

When you click the **Knit** button a document will be generated that includes both content as well as the output of any embedded R code chunks within the document. You can embed an R code chunk like this:

``` r
summary(cars)
```

    ##      speed           dist       
    ##  Min.   : 4.0   Min.   :  2.00  
    ##  1st Qu.:12.0   1st Qu.: 26.00  
    ##  Median :15.0   Median : 36.00  
    ##  Mean   :15.4   Mean   : 42.98  
    ##  3rd Qu.:19.0   3rd Qu.: 56.00  
    ##  Max.   :25.0   Max.   :120.00

Including Plots
---------------

You can also embed plots, for example:

![](README_files/figure-markdown_github/pressure-1.png)

Note that the `echo = FALSE` parameter was added to the code chunk to prevent printing of the R code that generated the plot.
