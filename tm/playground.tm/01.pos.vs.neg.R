# loads libraries
library(twitteR)
library(plyr)
library(stringr)
library(ggplot2)

## authenticates the twitter api key and saves the key
options(httr_oauth_cache=T) # allows twitteR to use a shared token
api_key ="NnsMrGv2CEF8g71LqVOiHdXeg"
api_secret ="OCt39dwLhpt9WFKRq3mD9k4o2zSRagLr3GZVBjBAFzAX09pe5I"
access_token ="142569552-AHcBcvwBckHbQOiWiwq99iXErWHJlQ7QRphyTHqz"
access_token_secret ="mftLRi6SDv0fJ09cePgw4ae5rAJNgY3KB7rW8K68mWXa0"
setup_twitter_oauth(api_key,api_secret,access_token,access_token_secret)

## loads the oauth key saved by previous section

### downloads and saves the tweets
tweets.to.viki = searchTwitteR("@viki", n=1500, lang="en")

head(tweets.to.viki)

tweets.about.viki = searchTwitter("#viki", n=1500, lang="en")

head(tweets.about.viki)

#save(delta.tweets, file="../data.tm/tweets.delta")
#american.tweets = searchTwitter('@AmericanAir', n=1500)
#save(american.tweets, file="../data.tm/tweets.american.rdata")

### loads the previously downloaded tweets
#load("../data.tm/tweets.delta.rdata")
#load("../data.tm/tweets.american.rdata")


# extracts the tweets' text

tweets.viki = c(tweets.to.viki, tweets.about.viki)

tweets.text = lapply(tweets.viki, function(x) x$getText())


# defines sentiment score function
score.sentiment <- function(sentences, pos.words, neg.words, .progress='none')
{
  scores = laply(sentences,
                 function(sentence, pos.words, neg.words)
                 {
                   sentence = gsub("[[:punct:]]", "", sentence)
                   sentence = gsub("[[:cntrl:]]", "", sentence)
                   sentence = gsub('\\d+', '', sentence)
                   tryTolower = function(x)
                   {
                     y = NA
                     try_error = tryCatch(tolower(x), error=function(e) e)
                     if (!inherits(try_error, "error"))
                       y = tolower(x)
                     return(y)
                   }
                   sentence = sapply(sentence, tryTolower)
                   word.list = str_split(sentence, "\\s+")
                   words = unlist(word.list)
                   pos.matches = match(words, pos.words)
                   neg.matches = match(words, neg.words)
                   pos.matches = !is.na(pos.matches)
                   neg.matches = !is.na(neg.matches)
                   score = sum(pos.matches) - sum(neg.matches)
                   return(score)
                 }, pos.words, neg.words, .progress=.progress )
  scores.df = data.frame(text=sentences, score=scores)
  return(scores.df)
}

## loads the list of positive and negative words
pos.words = scan(file='D:/textmining.sentiment/tm/data.tm/words.positive.txt',
                  what='character', comment.char=';')

neg.words = scan(file='D:/textmining.sentiment/tm/data.tm/words.negative.txt',
                  what='character', comment.char=';')

## checks the pos and neg arrays
head(pos.words)
head(neg.words)

## scores the sentiments
viki.scores = score.sentiment(head(tweets.text,60), pos.words,neg.words, .progress='text')
##american.scores = score.sentiment(head(american.text,60), pos.words,neg.words, .progress='text')

## checks the score datasets
viki.scores$score
#american.scores$score

## tags the stores
viki.scores$drama = 'viki'
#american.scores$airline = 'American'

## makes a graph of the scores
hist(viki.scores$score)
##hist(american.scores$score)

analysis = score.sentiment(tweets.text, pos.words, neg.words)
table(analysis$Score)


qplot(viki.scores$score)


#all.scores = rbind( american.scores,  delta.scores)

ggplot(data=viki.scores) + 
  geom_bar(mapping=aes(x=score, fill=drama), binwidth=1) +
  facet_grid(drama~.) +
  theme_bw() + scale_fill_brewer()

