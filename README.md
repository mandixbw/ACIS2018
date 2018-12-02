# Exploring social media analytics with R

# ACIS2018
Maria Prokofieva

Social media analytics (SMA) is a powerful tool that offer wide opportunities for academics and industry professionals. SMA relates to a number of tools to collect data from digital media platforms, process it into structured insights and assist in more information-driven decision making. SMA is an emerging paradigm which is characterized by high diversity of cross-disciplinary applications, interoperability challenges, data privacy issues, variety of available data types, diverse and heterogeneous data sources, cross-domain analytics and many other challenges. 

- R and RStudio installation (#R-install)
- [Packages to be used - please install] (#packages-to-use)
- [Reference material] (#reference-materia)

Topics covered during the tutorial include:

1. Benefits and challenges working with social media data (textual/non-textual information, large data volume, API access)

2. Structure of the social media data (e.g. user-related data, posting related data, hashtags)

3. Connecting to a social media platform (e.g. authentication) and downloading data 
- [Setting up API access for Twitter] (#setup-API)
- [Downloading tweets with `twitterR`] (#downloading-tweets)


4. Data analysis of the profile information (e.g. followers, likes, dislikes, favorites - platform dependent)
- [Analyse tweets] (#analyse-tweets)

5. Data analysis of textual information and non-textual (e.g. user posts, comments, dynamics, sentiment analysis, word clouds, etc.)

[Analyse text tweets] (#analyse-text)

6. Visualisation of the social media data

Keywords: Social media, data mining, text analysis, visualization, data science

Packages to install
===================

``` r
install.packages("twitteR")
install.packages("wordcloud2")
install.packages("tidyverse")
install.packages("tidytext")
install.packages("knitr")
install.packages("plotly")
devtools::install_github("ropenscilabs/icon") # to insert icons
devtools::install_github("hadley/emo") # to insert emoji
```

``` r
library(knitr)
library(magick)
library(png)
library(grid)
library(emo)
library(icon)
library(twitteR)
library(tidyverse)
```
