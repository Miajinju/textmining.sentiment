# load the libaries
library('twitteR') 

# encoding the user name on twitter 
user <- getUser('viki')

#exctract friends of user
friends <- user$getFriends()