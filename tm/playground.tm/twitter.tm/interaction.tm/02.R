# Script for graphing Twitter friends/followers

# load the required packages

library("twitteR")
          #install.packages("igraph")
library("igraph")

#authotization for the twitter 

api_key ="NnsMrGv2CEF8g71LqVOiHdXeg"
api_secret ="OCt39dwLhpt9WFKRq3mD9k4o2zSRagLr3GZVBjBAFzAX09pe5I"
access_token ="142569552-AHcBcvwBckHbQOiWiwq99iXErWHJlQ7QRphyTHqz"
access_token_secret ="mftLRi6SDv0fJ09cePgw4ae5rAJNgY3KB7rW8K68mWXa0"

options(httr_oauth_cache = T)
setup_twitter_oauth(api_key,api_secret,access_token,access_token_secret)


# Get User Information with twitteR function getUSer(), 

viki = getUser("viki") 

# Get Friends and Follower names with first fetching IDs (getFollowerIDs(),getFriendIDs()) 
  #and then looking up the names (lookupUsers()) 

friends.viki = lookupUsers(viki$getFriendIDs())

head(friends.viki)

follower.viki = lookupUsers(viki$getFollowerIDs())

# Retrieve the names of your friends and followers from the friend and follower objects. 
# You can limit the number of friends and followers with [1:n]
# friends and/or followers will be visualized.

n = 150
friends = sapply(friends.viki[1:n])
followers = sapply(followers.viki[1:n],name)

# Create a data frame that relates friends and followers to you for expression in the graph
relations = merge(data.frame(User='viki', Follower=friends), 
                   data.frame(User=followers, Follower='viki'), 
                  all=T)

# Create graph from relations.
g = graph.data.frame(relations, directed = T)

# Assign labels to the graph (=people's names)
V(g)$label = V(g)$name

# Plot the graph using plot() or tkplot(). 
tkplot(g)


