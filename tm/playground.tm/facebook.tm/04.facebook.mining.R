library(devtools)

install_github("pablobarbera/Rfacebook/Rfacebook")

require("Rfacebook")

fb_oauth <- fbOAuth(app_id="1699799983589026", app_secret="c5e2a7526eccbab584308d8ba3769e15",extended_permissions = TRUE)

save(fb_oauth, file="fb_oauth")

load("fb_oauth")


library(Rfacebook)
library(httpuv)
library(RColorBrewer)
library(httpuv)
library(httr)
library(RCurl)
library(rjson)

me = getUsers("me", token =fb_oauth)
my_like = getLikes(user="me", token=fb_oauth)
me
my_like
my_friends =getFriends(token=fb_oauth, simplify=F)
str(my_friends)
table(my_friends)

install.packages("pie")
pie(table(my_friends$relationship_status)col-brewer.pal(5,"set1"))
pie(table(my_friends$location),col-brewer.pal(20,"Greens"))
pie(table(my_friends$locale), col= brewer.pal(4,"Blues"))
pie(table(my_friends$gender), col= brewer.pal(3,"orange"))
textF="applyingR- Datamining Facebook"
linkF=""
updateStatus(textF. token= fb_oauth, link= linkF)

install.packages("igraph")
library(igragh)
tmp =getNetwork(fb_oauth, format = "adj.matrix")
network = graph.adjacency(tmp, mode="undirected")

set.seed(1)
L = layout.fruchterman.reingold(network)
L[,1]=(L[,1]-min(L[,1]))/(max(L[,1]))*2-1
L[,2]=(L[,2]-min(L[,2]))/(max(L[,2]))*2-1

pdf("net_work_plot.pdf", width = 50, height = 50)
plot(network, layout=L, vertex.size=0,vertex.frame.color="#0000000",edge.courved=FALSE, edge.color=rainbow(500),vertex.label.cex=3, edge.width=6)