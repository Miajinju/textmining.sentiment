#authotization for the twitter 


api_key ="NnsMrGv2CEF8g71LqVOiHdXeg"
api_secret ="OCt39dwLhpt9WFKRq3mD9k4o2zSRagLr3GZVBjBAFzAX09pe5I"
access_token ="142569552-AHcBcvwBckHbQOiWiwq99iXErWHJlQ7QRphyTHqz"
access_token_secret ="mftLRi6SDv0fJ09cePgw4ae5rAJNgY3KB7rW8K68mWXa0"

options(httr_oauth_cache = T)
setup_twitter_oauth(api_key,api_secret,access_token,access_token_secret)

# load the package
require("RCurl")
top.100 = getURL("http://twittercounter.com/pages/100")
devtools::install_github("lmullen/gender")
require("gender")


# split into lines
top.100 = unlist(strsplit(top.100, "\n"))
head(top.100)

# Get only those lines with an @
top.100 = top.100[sapply(top.100, grepl, pattern="@")]
head(top.100)

# Grep out anchored usernames: <a ...>@username</a>
top.100 = gsub(".*>@(.+)<.*", "\\1", top.100)[2:101]
head(top.100)


# Try to sample 300 followers for a user:
username$getFollowers(n=300)

# Error in twFromJSON(out) :
#  Error: Malformed response from server, was not JSON.
# The most likely cause of this error is Twitter returning
# a character which can't be properly parsed by R. Generally
# the only remedy is to wait long enough for the offending
# character to disappear from searches.

gender("ben")


