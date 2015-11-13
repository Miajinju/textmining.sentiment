# load libraries
#install.packages("maps")
#install.packages("geosphere")
source('http://biostat.jhsph.edu/~jleek/code/twitterMap.R')
library(twitteR)
library(maps)

#authotization for the twitter 

api_key ="NnsMrGv2CEF8g71LqVOiHdXeg"
api_secret ="OCt39dwLhpt9WFKRq3mD9k4o2zSRagLr3GZVBjBAFzAX09pe5I"
access_token ="142569552-AHcBcvwBckHbQOiWiwq99iXErWHJlQ7QRphyTHqz"
access_token_secret ="mftLRi6SDv0fJ09cePgw4ae5rAJNgY3KB7rW8K68mWXa0"

options(httr_oauth_cache = T)
setup_twitter_oauth(api_key,api_secret,access_token,access_token_secret)


# encoding the user name on twitter 
user = getUser('viki')

#exctract friends of user
friends = user$getFriends()

head(friend,100)

# defind the function
twitterMap = function(viki, userLocation=NULL, fileName='twitterMap.pdf', nMax = 1000, plotType=c('followers','both','followings'))

##userName – the twitter username you want to plot
##userLocation – an optional argument giving the location of the user, 
  ##necessary when the location information you have provided Twitter isn’t sufficient for us to find latitude/longitude data
##fileName – the file where you want the plot to appear
##nMax – The maximum number of followers/following to get from Twitter, this is implemented to avoid rate limiting for people with large numbers of followers. 
##plotType – if “both” both followers/following are plotted, etc.
  

twitterMap('simplystats')

#?# cannot find the > data(followers.viki)

##grep('Baltimore', world.cities[,1])

#If your city is in the database, 
#this will return the row number of the world.
#cities data frame corresponding to your city. 

