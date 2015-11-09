# load all the libraries for frequent used words on Tweet about viki

library(twitteR)
library(sentiment)
library(plyr)
library(ggplot2)
library(wordcloud)
library(RColorBrewer)
library(tm)
library(SnowballC)
library(ggplot2)
library(devtools)
library(graph)
library(Rgraphviz)
library(wordcloud)

#authotization for the twitter 

options(httr_oauth_cache = T)
api_key ="NnsMrGv2CEF8g71LqVOiHdXeg"
api_secret ="OCt39dwLhpt9WFKRq3mD9k4o2zSRagLr3GZVBjBAFzAX09pe5I"
access_token ="142569552-AHcBcvwBckHbQOiWiwq99iXErWHJlQ7QRphyTHqz"
access_token_secret ="mftLRi6SDv0fJ09cePgw4ae5rAJNgY3KB7rW8K68mWXa0"

setup_twitter_oauth(api_key,api_secret,access_token,access_token_secret)
save(setup_twitter_oauth)

# loading the data on viki

## loading the data to viki 
tweets.to.viki = searchTwitteR("@viki", n=1500, lang="en")

head(tweets.to.viki)

## loading the data about viki
tweets.about.viki = searchTwitter("#viki", n=1500, lang="en")

head(tweets.about.viki)

## get the text about viki

tweets.viki = c(tweets.to.viki, tweets.about.viki)

tweets.text = lapply(tweets.viki, function(x) x$getText())

head(tweets.text, 10)

#most used words
tweets = userTimeline("Viki", n = 3200)

head(tweets,100)

tweets = userTimeline("@Viki", n = 3200)

head(tweets,100)

## convert viki usertime data to a data frame 

df.tweets <- twListToDF(tweets)

## convert tweets about viki to a data frame 

df.tweeters = twListToDF(tweets.viki)

### check the dimention of tweets

dim(df.tweets)

dim(df.tweeters)

## make the df. tweets in order

for (i in c(1:2, 320)) {
  
  cat(paste0("[", i, "] "))
  
  writeLines(strwrap(df.tweets$text[i], 60))
  
}

## make the df.tweeters in order

for (i in c(1:2, 320)) {
  
  cat(paste0("[", i, "] "))
  
  writeLines(strwrap(df.tweeters$text[i], 60))
  
}

# defining the corpus of df.tweets

myCorpus <- Corpus(VectorSource(df.tweets$text))
myCorpus <- tm_map(myCorpus, content_transformer(tolower))

# cleaning the context 
## remove URLs

removeURL <- function(x) gsub("http[^[:space:]]*", "", x)
myCorpus <- tm_map(myCorpus, content_transformer(removeURL))


## remove anything other than English letters or space

removeNumPunct <- function(x) gsub("[^[:alpha:][:space:]]*", "", x)
myCorpus <- tm_map(myCorpus, content_transformer(removeNumPunct))

## remove punctuation

myCorpus <- tm_map(myCorpus, removePunctuation)

## remove numbers

myCorpus <- tm_map(myCorpus, removeNumbers)

## add two extra stop words: "available" and "via"

myStopwords <- c(stopwords('english'), "available", "via")

## remove "r" and "big" from stopwords

myStopwords <- setdiff(myStopwords, c("r", "big"))

## remove stopwords from corpus

myCorpus <- tm_map(myCorpus, removeWords, myStopwords)

## remove extra whitespace

myCorpus <- tm_map(myCorpus, stripWhitespace)

## keep a copy of corpus to use later as a dictionary for stem completion

myCorpusCopy <- myCorpus

## stem words

myCorpus <- tm_map(myCorpus, stemDocument)

# I cannot understand this
## inspect the first 5 documents (tweets)

###inspect(myCorpus[1:5])

# for the moment no without this code
## The code below is used for to make text fit for paper width

##for (i in c(1:2, 320)) {
  
##  cat(paste0("[", i, "] "))
  
##  writeLines(strwrap(as.character(myCorpus[[i]]), 60))
  
##}


# tm v0.6

stemCompletion2 <- function(x, dictionary) {
  
  x <- unlist(strsplit(as.character(x), " "))
  
  
  
  x <- x[x != ""]
  
  x <- stemCompletion(x, dictionary=dictionary)
  
  x <- paste(x, sep="", collapse=" ")
  
  PlainTextDocument(stripWhitespace(x))
  
}

myCorpus <- lapply(myCorpus, stemCompletion2, dictionary=myCorpusCopy)

myCorpus <- Corpus(VectorSource(myCorpus))


# count frequency of "kpop"

miningCases <- lapply(myCorpusCopy,
                      
                      function(x) { grep(as.character(x), pattern = "\\<kpop")} )

sum(unlist(miningCases))



# count frequency of "jiseongjoon"

minerCases <- lapply(myCorpusCopy,
                     
                     function(x) {grep(as.character(x), pattern = "\\<jiseongjoon")} )

sum(unlist(minerCases))


#No I will not going to change
## replace "Kdrama" with "Korean"

#myCorpus <- tm_map(myCorpus, content_transformer(gsub),
                   
 #                  pattern = "kdrama", replacement = "Viki")

tdm <- TermDocumentMatrix(myCorpus,
                          
                         control = list(wordLengths = c(1, Inf)))

idx <- which(dimnames(tdm)$Terms == "viki")

inspect(tdm[idx + (0:5), 101:110])


(freq.terms <- findFreqTerms(tdm, lowfreq = 15))



term.freq <- rowSums(as.matrix(tdm))

term.freq <- subset(term.freq, term.freq >= 15)

df <- data.frame(term = names(term.freq), freq = term.freq)

#make the graph about it 

ggplot(df, aes(x = term, y = freq)) + geom_bar(stat = "identity") +
  
  xlab("Terms") + ylab("Count") + coord_flip()

# which words are associated with 'r'?

##findAssocs(tdm, "like", 0.2)



# which words are associated with 'viki'?

##findAssocs(tdm, "hate", 0.25)



source("https://bioconductor.org/biocLite.R")
biocLite("RBGL")

#install_url("http://cran.r-project.org/src/contrib/Archive/graph/graph_1.30.0.tar.gz")




source("https://bioconductor.org/biocLite.R")
biocLite("Rgraphviz")



plot(tdm, term = freq.terms, corThreshold = 0.1, weighting = T)

m <- as.matrix(tdm)

# calculate the frequency of words and sort it by frequency

word.freq <- sort(rowSums(m), decreasing = T)

# colors

pal <- brewer.pal(9, "BuGn")

pal <- pal[-(1:4)]

# plot word cloud

wordcloud(words = names(word.freq), freq = word.freq, min.freq = 3, random.order = F, colors = pal)
