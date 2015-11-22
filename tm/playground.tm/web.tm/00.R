rm(list = ls(all = TRUE)) #CLEAR WORKSPACE
library(quantmod)

#Scrape data from the website
library(XML)
rawPMI <- readHTMLTable('http://www.ism.ws/ISMReport/content.cfm?ItemNumber=10752')
PMI <- data.frame(rawPMI[[1]])
names(PMI)[1] <- 'Year'

#Reshape
library(reshape2)
PMI <- melt(PMI,id.vars='Year')
names(PMI) <- c('Year','Month','PMI')
PMI$PMI <- as.numeric(as.character(PMI$PMI))
PMI <- na.omit(PMI)

#Convert to XTS
library(xts)
numMonth <- function(x) {
  months <- list(jan=1,feb=2,mar=3,apr=4,may=5,jun=6,jul=7,aug=8,sep=9,oct=10,nov=11,dec=12)
  x <- tolower(x)
  sapply(x,function(x) months[[x]])
}
PMI$Month <- numMonth(PMI$Month)
PMI$Date <- paste(PMI$Year,PMI$Month,'1',sep='-')
PMI$Date <- as.Date(PMI$Date,format='%Y-%m-%d')
PMI <- xts(PMI$PMI,order.by=PMI$Date)
names(PMI) <- 'PMI'
plot(PMI)