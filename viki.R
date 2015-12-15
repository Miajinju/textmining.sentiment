##-------------------Download package ------------------

install.packages("RCurl")

##------------------library---------------------------
library(rjson)
library(jsonlite)
library(RCurl)

##-----------------Scrawling data -----------------

viki.1 = fromJSON(/v4/movies.json, flatten = FALSE)
viki.2 = fromJSON(getURL('https://s3.amazonaws.com/bucket/my.json'))