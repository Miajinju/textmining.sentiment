#authotization for the twitter 


api_key ="NnsMrGv2CEF8g71LqVOiHdXeg"
api_secret ="OCt39dwLhpt9WFKRq3mD9k4o2zSRagLr3GZVBjBAFzAX09pe5I"
access_token ="142569552-AHcBcvwBckHbQOiWiwq99iXErWHJlQ7QRphyTHqz"
access_token_secret ="mftLRi6SDv0fJ09cePgw4ae5rAJNgY3KB7rW8K68mWXa0"

options(httr_oauth_cache = T)
setup_twitter_oauth(api_key,api_secret,access_token,access_token_secret)

# load the libaries
library('twitteR') 

# encoding the user name on twitter 
user = getUser('viki')

#exctract friends of user
friends = user$getFriends()