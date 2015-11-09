require("RCurl")
top.100 <- getURL("http://twittercounter.com/pages/100")

# split into lines
top.100 <- unlist(strsplit(top.100, "\n"))
# Get only those lines with an @
top.100 <- top.100[sapply(top.100, grepl, pattern="@")]

# Grep out anchored usernames: <a ...>@username</a>
top.100 <- gsub(".*>@(.+)<.*", "\\1", top.100)[2:101]
head(top.100)
# [1] "katyperry"  "justinbieber"  "BarackObama"  ...

# Try to sample 3000 followers for a user:
username$getFollowers(n=3000)
# Error in twFromJSON(out) :
#  Error: Malformed response from server, was not JSON.
# The most likely cause of this error is Twitter returning
# a character which can't be properly parsed by R. Generally
# the only remedy is to wait long enough for the offending
# character to disappear from searches.

devtools::install_github("lmullen/gender")
require("gender")
gender("ben")
#   name proportion_male proportion_female gender
# 1  ben          0.9962            0.0038   male

