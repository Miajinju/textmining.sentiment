library("twitteR")
#get data
TB<-searchTwitter("tinderbox", lan="da", n=10000)
#put into a dataframe
df <- do.call("rbind", lapply(TB, as.data.frame))
library(twitteR)
user <- getUser("krestenb")
followers <- user$getFollowers()
b <- twListToDF(followers)
f_count <- as.data.frame(b$followersCount)
u_id <- as.data.frame(b$id)
u_sname <- as.data.frame(b$screenName)
u_name <- as.data.frame(b$name)

final_df <- cbind(u_id,u_name,u_sname,f_count)
sort_fc <- final_df[order(-f_count),]
colnames(sort_fc) <- c('id','name','s_name','fol_count')

#create a data frame with 4 columns and no rows initially
df_result <- data.frame(t(rep(NA, 4)))
names(df_result) <- c('id', 'name', 's_name', 'fol_count')
df_result <- df_result[0:0,]

# you can replace this vector with whatever set of Twitter users you want
users <- c("krestenb", "tjb25587")                    # tjb25587 (me) has no followers

sapply(users, function(x) {
  user <- getUser(x)
  followers <- user$getFollowers()
  if (length(followers) > 0) {        # ignore users with no followers
    b <- twListToDF(followers)
    f_count <- as.data.frame(b$followersCount)
    u_id <- as.data.frame(b$id)
    u_sname <- as.data.frame(b$screenName)
    u_name <- as.data.frame(b$name)
    final_df <- cbind(u_id,u_name,u_sname,f_count)
    sort_fc <- final_df[order(-f_count),]
    colnames(sort_fc) <- c('id','name','s_name','fol_count')
    df_result <<- rbind(df_result, sort_fc)
  }
})
