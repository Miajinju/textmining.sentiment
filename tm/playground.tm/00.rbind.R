delta.twittes = searchTwitteR("delta", n=1500, lang="en")
delta.twitter = searchTwitteR("@delta", n=1500, lang = "en")
delta.twitte = searchTwitter("#delta", n=1500, lang ="en")

twitte_delta = rbind(delta.twittes,delta.twitter,delta.twitte)
tweet = twitte_delta[[1]]
class(tweet)
tweet$getScreenName()
tweet$getText()
tweet_text = lapply(twitte_delta, function(t) t$getText())
length(twee_text)
length(tweet_text)
head(tweet_text, 5)
