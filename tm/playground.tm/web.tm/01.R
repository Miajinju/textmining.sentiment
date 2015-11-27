#-------------------install packages ---------------------

install.packages('rvest')

#-------------------library-----------------------------
  
  library(rvest)

# ---------------extract data---------------------------
#lego_movie <- html("http://www.imdb.com/title/tt1490017/")
epi = html("https://disqus.com/embed/comments/?base=default&version=7bc87d1330c2b2e260ee5892e4ebef9e&f=vikiorg&t_i=1088594v&t_u=https%3A%2F%2Fwww.viki.com%2Fvideos%2F1088594v-oh-my-venus-episode-4&t_d=Oh%20My%20Venus%20Episode%204%20-%20오%20마이%20비너스%20-%20Watch%20Full%20Episodes%20Free%20-%20Korea%20-%20TV%20Shows%20-%20Viki&t_t=Oh%20My%20Venus%20Episode%204%20-%20오%20마이%20비너스%20-%20Watch%20Full%20Episodes%20Free%20-%20Korea%20-%20TV%20Shows%20-%20Viki&s_o=default&l=en") 

#lego_movie %>% 
#  html_node("strong span") %>%
#  html_text() %>%
#  as.numeric()
epi %>%
  html_node("") %>%
  html_text() %>%
  as.uumeric()

? html_node
#lego_movie %>%
  #html_nodes("#titleCast .itemprop span") %>%
  #html_text()

#------------data frame with table--------------------
lego_movie %>%
  html_nodes("table") %>%
  .[[3]] %>%
  html_table()

#Extract the tag names with html_tag(), text with html_text(), a single attribute with html_attr() or all attributes with html_attrs().

#Detect and repair text encoding problems with guess_encoding() and repair_encoding().

#Navigate around a website as if you’re in a browser with html_session(), jump_to(), follow_link(), back(), and forward(). Extract, modify and submit forms with html_form(), set_values() and submit_form(). (This is still a work in progress, so I’d love your feedback.)

#To see these functions in action, check out package demos with demo(package = "rvest").