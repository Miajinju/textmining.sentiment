##-------------------Download package ------------------

install.packages("RCurl")
install.packages("digest")
install_github("marcoplebani85/crypto")

##------------------library---------------------------
library(rjson)
library(jsonlite)
library(RCurl)
library(digest)
library(devtools)

##-----------------Using package -----------------
 
str(digest)
str(hmac)

##--------------------playing------------------------

hmac("c80f43eaa234dd4207197014562909bfafe0deb31ad27d4e96dafc89b81f59b1ad659968
", "/v4/movies.json?sort=views&app=100485a&t=1356482778", algo="sha1")
