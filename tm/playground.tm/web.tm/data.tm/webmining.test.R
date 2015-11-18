# ----------------install packages --------------------------------------------------

# ----------------require packages--------------------------------------------------
library(tm)
library(tm.plugin.webmining)

  ## a (Web-)Corpus using data from Yahoo! News and the search query "Microsoft"
  ## The most of data is from HTML

#--------------------extract data--------------------------------------------------
yahoonews <- WebCorpus(YahooNewsSource("Microsoft"))
class(yahoonews)
yahoonews


#--------------------data examine---------------------------------------------------
#TextDocument = meta–data like DateTimeStamp, Description, Heading, ID and Origin.
meta(yahoonews[[1]])   
   
#The main content (Origin of a TextDocument) can be examined 
yahoonews[[1]]

#------------To view the entire corpus main content-----------------------------
inspect(yahoonews)

#--------------------Implemented Sources--------------------------
googlefinance <- WebCorpus(GoogleFinanceSource("NASDAQ:MSFT"))
googlenews <- WebCorpus(GoogleNewsSource("Microsoft"))
nytimes <- WebCorpus(NYTimesSource("Microsoft", appid = nytimes_appid))
reutersnews <- WebCorpus(ReutersNewsSource("businessNews"))
yahoofinance <- WebCorpus(YahooFinanceSource("MSFT"))
yahooinplay <- WebCorpus(YahooInplaySource())
yahoonews <- WebCorpus(YahooNewsSource("Microsoft"))

#---------------Extending/Updating Corpora-------------
yahoonews <- corpus.update(yahoonews)



