library(XML)

swim_wiki = "http://en.wikipedia.org/wiki/World_record_progression_1500_metres_freestyle"

swim1500 = readHTMLTable(swim_wiki, which = 1, stringsAsFactors = FALSE)

head(swim1500)
