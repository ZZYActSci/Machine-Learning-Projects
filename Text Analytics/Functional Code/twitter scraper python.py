#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Oct 12 22:47:09 2021
@author: yandatao
"""
# This code shows how to scrape twitter by using the snscrape python API
# Please make sure the snscrape has been installed in the local environment
# The snscape package can be installed by: pip3 install git+https://github.com/JustAnotherArchivist/snscrape.git
# The Python version has to be greater than 3.8
# An alternative Python method is to to execute CLI commands in Python. 
# Please check this link for more details: https://colab.research.google.com/drive/1ugr1biGxV9C2OwzS3HEh3KM0z2Xg44jb?usp=sharing

import snscrape.modules.twitter as sntwitter
import pandas as pd

key_word = "python 3.8"  # Declare the key word used to search tweets
user_name = "@mcgillu"   # Declare a user name used to search tweets
from_date = "2020-01-01" # Declare a start date
end_date = '2020-02-01'  # Declare a end date
count = 200              # The maximum number of tweets
tweets_list_keyword = [] # A list used to store the returned results for keyword search
tweets_list_user = []    # A list used to store the retuned results for user search


#### Scraping tweets from a text search query ####
command_keyword = key_word+' since:'+from_date+' until:'+end_date # Define a string command for Scraper Api
print("Scraping data for keyword:",key_word)
for i,tweet in enumerate(sntwitter.TwitterSearchScraper(command_keyword).get_items()):
    tweets_list_keyword.append([tweet.date,tweet.id, tweet.content, tweet.user.username, tweet.url]) # Append returned results to list
    if i>count:
        break;
# Create a dataframe from the tweets list above 
tweets_df_keyword = pd.DataFrame(tweets_list_keyword, columns=['Datetime','Tweet Id', 'Text', 'Username', 'url'])
tweets_df_keyword.to_csv("tweets_keywords.csv",index=False) # Export to a csv file
print("Scraped data have been exported to the csv file")



#### Scraping tweets a specific Twitter user’s account ####
command_user = 'from:'+user_name+' since:'+from_date+' until:'+end_date
print("Scraping data for user:",user_name)
for i,tweet in enumerate(sntwitter.TwitterSearchScraper(command_user).get_items()): 
    tweets_list_user.append([tweet.date,tweet.id, tweet.content, tweet.user.username, tweet.url]) 
    if i > count:
        break;
# Create a dataframe from the tweets list above 
tweets_df_user = pd.DataFrame(tweets_list_user, columns=['Datetime','Tweet Id', 'Text', 'Username', 'url'])
tweets_df_user.to_csv("tweets_users.csv",index=False) # Export to a csv file
print("Scraped data have been exported to the csv file")