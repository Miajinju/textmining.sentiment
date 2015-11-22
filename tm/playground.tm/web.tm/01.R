install.packages
#To see rvest in action, imagine we’d like to scrape some information about The Lego Movie from IMDB. We start by downloading and parsing the file with html():
  
  library(rvest)
lego_movie <- html("http://www.imdb.com/title/tt1490017/")
 
#We use html_node() to find the first node that matches that selector, extract its contents with html_text(), and convert it to numeric with as.numeric():
lego_movie %>% 
  html_node("strong span") %>%
  html_text() %>%
  as.numeric()

#We use a similar process to extract the cast, using html_nodes() to find all nodes that match the selector
lego_movie %>%
  html_nodes("#titleCast .itemprop span") %>%
  html_text()

#The titles and authors of recent message board postings are stored in a the third table on the page. We can use html_node() and [[ to find it, then coerce it to a data frame with html_table(
lego_movie %>%
  html_nodes("table") %>%
  .[[3]] %>%
  html_table()

#If you prefer, you can use xpath selectors instead of css: 
html_nodes(doc, xpath = "//table//td").
#Extract the tag names with html_tag(), text with html_text(), a single attribute with html_attr() or all attributes with html_attrs().

#Detect and repair text encoding problems with guess_encoding() and repair_encoding().

#Navigate around a website as if you’re in a browser with html_session(), jump_to(), follow_link(), back(), and forward(). Extract, modify and submit forms with html_form(), set_values() and submit_form(). (This is still a work in progress, so I’d love your feedback.)

#To see these functions in action, check out package demos with demo(package = "rvest").