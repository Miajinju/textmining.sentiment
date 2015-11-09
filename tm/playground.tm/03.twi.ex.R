#Step 1: Load the necessary packages
# required pakacges
library(twitteR)
library(sentiment)
library(plyr)
library(ggplot2)
library(wordcloud)
library(RColorBrewer)

#Step 2: Let's collect some tweets containing the term "starbucks" 
# harvest some tweets
tweets.to.viki = searchTwitteR("@viki", n=1500, lang="en")

head(tweets.to.viki)

tweets.about.viki = searchTwitter("#viki", n=1500, lang="en")

head(tweets.about.viki)

tweets.viki = c(tweets.to.viki, tweets.about.viki)

# get the text
tweets.text = lapply(tweets.viki, function(x) x$getText())
#Step 3: Prepare the text for sentiment analysis
# remove retweet entities
tweets.text = gsub("(RT|via)((?:\\b\\W*@\\w+)+)", "", tweets.text )
# remove at people
tweets.text = gsub("@\\w+", "", tweets.text)
# remove punctuation
tweets.text = gsub("[[:punct:]]", "", tweets.text)
# remove numbers
tweets.text = gsub("[[:digit:]]", "", tweets.text)
# remove html links
tweets.text = gsub("http\\w+", "", tweets.text)
# remove unnecessary spaces
tweets.text = gsub("[ \t]{2,}", "", tweets.text)
tweets.text = gsub("^\\s+|\\s+$", "", tweets.text)

# define "tolower error handling" function 
try.error = function(x)
{
  # create missing value
  y = NA
  # tryCatch error
  try_error = tryCatch(tolower(x), error=function(e) e)
  # if not an error
  if (!inherits(try_error, "error"))
  y = tolower(x)
  # result
  return(y)
}
# lower case using try.error with sapply 
tweets.text = sapply(tweets.text, try.error)

# remove NAs in tweets.text
tweets.text = tweets.text[!is.na(tweets.text)]
names(tweets.text) = NULL

#Step 4: Perform Sentiment Analysis
# classify emotion
class_emo = classify_emotion(tweets.text, algorithm="bayes", prior=1.0)
# get emotion best fit
emotion = class_emo[,7]
# substitute NA's by "unknown"
emotion[is.na(emotion)] = "unknown"

# classify polarity
class_pol = classify_polarity(tweets.text, algorithm="bayes")
# get polarity best fit
polarity = class_pol[,4]

#Step 5: Create data frame with the results and obtain some general statistics
# data frame with results
df.viki = data.frame(text=tweets.text, emotion=emotion,
                     polarity=polarity, stringsAsFactors=FALSE)

# sort data frame
df.viki = within(df.viki,
                 emotion <- factor(emotion, levels=names(sort(table(emotion), decreasing=TRUE))))

#Step 6: Let's do some plots of the obtained results
# plot distribution of emotions
ggplot(df.viki, aes(x=emotion))+ 
geom_bar(aes(y=..count.., fill=emotion))+
scale_fill_brewer(palette="Dark2") +
labs(x="emotion categories", y="number of tweets") 
opts(title = "Sentiment Analysis of Tweets about viki\n(classification by emotion)",
     plot.title = theme_text(size=12))
# plot distribution of polarity
ggplot(df.viki, aes(x=polarity)) +
geom_bar(aes(y=..count.., fill=polarity)) +
scale_fill_brewer(palette="RdGy") +
labs(x="polarity categories", y="number of tweets") +
opts(title = "Sentiment Analysis of Tweets about viki\n(classification by polarity)",
     plot.title = theme_text(size=12))

#Step 7: Separate the text by emotions and visualize the words with a comparison cloud
# separating text by emotion
emos = levels(factor(df.viki$emotion))
nemo = length(emos)
emo.docs = rep("", nemo)
for (i in 1:nemo)
{
  tmp = tweets.text[emotion == emos[i]]
  emo.docs[i] = paste(tmp, collapse=" ")
}

# remove stopwords
emo.docs = removeWords(emo.docs, stopwords("english"))
# create corpus
corpus = Corpus(VectorSource(emo.docs))
tdm = TermDocumentMatrix(corpus)
tdm = as.matrix(tdm)
colnames(tdm) = emos

# comparison word cloud
comparison.cloud(tdm, colors = brewer.pal(nemo, "Dark2"),
scale = c(3,.5), random.order = FALSE, title.size = 1.5)

