# load code 
library(twitteR)
library(plyr)
library(stringr)

## authenticates the twitter api key and saves the key
options(httr_oauth_cache=T) # allows twitteR to use a shared token
api_key ="NnsMrGv2CEF8g71LqVOiHdXeg"
api_secret ="OCt39dwLhpt9WFKRq3mD9k4o2zSRagLr3GZVBjBAFzAX09pe5I"
access_token ="142569552-AHcBcvwBckHbQOiWiwq99iXErWHJlQ7QRphyTHqz"
access_token_secret ="mftLRi6SDv0fJ09cePgw4ae5rAJNgY3KB7rW8K68mWXa0"
setup_twitter_oauth(api_key,api_secret,access_token,access_token_secret)

### downloads and saves the tweets

wine.tweets = searchTwitter("wine", n=500, lang="en")
beer.tweets = searchTwitter("beer", n=500, lang="en")
cofe.tweets = searchTwitter("coffee", n=500, lang="en")
soda.tweets = searchTwitter("soda", n=500, lang="en")

## # extracts the tweets' text
wine.txt = lapply(wine.tweets, function(x) x$getText())
beer.txt = lapply(beer.tweets, function(x) x$getText())
cofe.txt = lapply(cofe.tweets, function(x) x$getText())
soda.txt = lapply(soda.tweets, function(x) x$getText())

# sore sentiment 
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
pos.words = scan(file='C:/Users/SAMSUNG/testingTextMiningTools/tm/data.tm/words.positive.txt',
                 what='character', comment.char=';')

neg.words = scan(file='C:/Users/SAMSUNG/testingTextMiningTools/tm/data.tm/words.negative.txt',
                 what='character', comment.char=';')

##check the pos and neg arrays
head(pos.words)
head(neg.words)

## scores the sentiments
wine.scores = score.sentiment(head(wine.text,60), pos.words,neg.words, .progress='text')
beer.scores = score.sentiment(head(beer.text,60), pos.words,neg.words, .progress='text')
cofe.scores = score.sentiment(head(cofe.text, 60),pos.words,neg.words, .progress='text')
soda.scores = score.sentiment(head(soda.text,60), pos.words,neg.words, .progress='text')

## checks the score datasets
wine.scores$score
beer.scores$score
cofe.scores$score
soda.scores$score

## tags the stores
wine.scores$beverage = 'Wine'
beer.scores$beverage = 'beer'
cofe.scores$beverage = 'cofe'
soda.scores$beverage = 'soda'

# analysis = score.sentiment(delta.text, pos.words, neg.words)
# table(analysis$Score)

qplot(delta.scores$score)


all.scores = rbind( american.scores,  delta.scores)

ggplot(data=all.scores) + 
  geom_bar(mapping=aes(x=score, fill=airline), binwidth=1) +
  facet_grid(airline~.) +
  theme_bw() + scale_fill_brewer()


scores$drink = factor(rep(c("wine", "beer", "coffee", "soda"), nd))
scores$very.pos = as.numeric(scores$score >= 2)
scores$very.neg = as.numeric(scores$score <= -2)


numpos = sum(scores$very.pos)
numneg = sum(scores$very.neg)


global_score = round( 100 * numpos / (numpos + numneg) )


cols = c("#7CAE00", "#00BFC4", "#F8766D", "#C77CFF")
names(cols) = c("beer", "coffee", "soda", "wine")

# Graph 

ggplot(scores, aes(x=drink, y=score, group=drink)) +
geom_boxplot(aes(fill=drink)) +
scale_fill_manual(values=cols) +
geom_jitter(colour="gray40",
position=position_jitter(width=0.2), alpha=0.3) +
labs(title = "Boxplot - Drink's Sentiment Scores")

meanscore = tapply(scores$score, scores$drink, mean)
df = data.frame(drink=names(meanscore), meanscore=meanscore)
df$drinks <- reorder(df$drink, df$meanscore)

ggplot(df, aes(y=meanscore)) +
  geom_bar(data=df, aes(x=drinks, fill=drinks)) +
  scale_fill_manual(values=cols[order(df$meanscore)]) +
  labs(title = "Average Sentiment Score",
       legend.position = "none")

drink_pos = ddply(scores, .(drink), summarise, mean_pos=mean(very.pos))
drink_pos$drinks <- reorder(drink_pos$drink, drink_pos$mean_pos)

ggplot(drink_pos, aes(y=mean_pos)) +
geom_bar(data=drink_pos, aes(x=drinks, fill=drinks)) +
scale_fill_manual(values=cols[order(drink_pos$mean_pos)]) +
labs(title = "Average Very Positive Sentiment Score",
    legend.position = "none")


drink_neg = ddply(scores, .(drink), summarise, mean_neg=mean(very.neg))
drink_neg$drinks <- reorder(drink_neg$drink, drink_neg$mean_neg)

ggplot(drink_neg, aes(y=mean_neg)) +
  geom_bar(data=drink_neg, aes(x=drinks, fill=drinks)) +
  scale_fill_manual(values=cols[order(drink_neg$mean_neg)]) +
  labs(title = "Average Very Negative Sentiment Score",
       legend.position = "none")

