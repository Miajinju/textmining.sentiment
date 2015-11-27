#-------------------install packages---------------------
install.packages('quantmod')

#---------------------library---------------------------

library(quantmod)
library(XML)
library(reshape2)
library(xts)


#-------------------Scrape data from the website---------

raw.epi.4<- readHTMLTable('https://www.viki.com/videos/1088594v-oh-my-venus-episode-4')
 epi.4<- data.frame(raw.epi.4[[1]])

#-------------------Reshape-------------------------------
epi.4 <- melt(epi.4,id.vars='Year')
names(epi.4) <- c('Year','Month','PMI')
epi.4$epi.4 <- as.numeric(as.character(epi.4$epi.4))
epi.4 <- na.omit(ep1.4)

#------------------Convert to XTS----------------------------

numMonth <- function(x) {
  months <- list(jan=1,feb=2,mar=3,apr=4,may=5,jun=6,jul=7,aug=8,sep=9,oct=10,nov=11,dec=12)
  x <- tolower(x)
  sapply(x,function(x) months[[x]])
}
epi.4$Month <- numMonth(epi.4$Month)
epi.4$Date <- paste(epi.4$Year,epi.4$Month,'1',sep='-')
epi.4$Date <- as.Date(epi.4$Date,format='%Y-%m-%d')
epi.4 <- xts(epi.4$epi.4,order.by=epi.4$Date)
names(epi.4) <- 'epi.4'
plot(epi.4)