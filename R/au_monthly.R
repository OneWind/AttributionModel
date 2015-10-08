query <- 'select datepart(month, servertimemst) mn, subchannel
               , sum(firsttouchweights_update) channelweight
               , sum(tvweights_ft) tvweight
          from a.feng_au_visit_tv_signup
          group by datepart(month, servertimemst), subchannel'

data <- sqlQuery(.dwMatrix, query)
data$subchannel <- gsub("[^a-zA-Z]+", " ", data$subchannel)
data$subchannel <- gsub("[ ]+$", "", data$subchannel)

online <- reshape(data[, 1:3], v.names="channelweight", timevar="mn",
                  idvar="subchannel", direction="wide")
names(online)[2:ncol(online)] <- gsub("channelweight.", "", names(online)[2:ncol(online)])
online[, 2:ncol(online)] <- online[, order(names(online)[2:ncol(online)])+1]
names(online)[2:ncol(online)] <- month.name[1:6]
online[is.na(online)] <- 0


tv.lst <- split(data$tvweight, data$mn)
tv.bymonth <- unlist(lapply(tv.lst, sum))
tv <- data.frame(subchannel="TV", 
                 January=tv.bymonth[1], February=tv.bymonth[2], March=tv.bymonth[3],
                 April=tv.bymonth[4], May=tv.bymonth[5], June=tv.bymonth[6])

monthly <- rbind(tv, online)
monthly$Total <- rowSums(monthly[, 2:7])
monthly <- monthly[order(monthly$Total, decreasing=T), ]

write.csv(monthly, 
          file="\\\\corpshares\\Analytics\\Feng\\AttrNew\\results\\au_ft_monthly.csv", 
          row.names=F)


query <- 'select datepart(month, servertimemst) mn, subchannel
               , sum(lasttouchweights_update) channelweight
               , sum(tvweights_lt) tvweight
          from a.feng_au_visit_tv_signup
          group by datepart(month, servertimemst), subchannel'

data <- sqlQuery(.dwMatrix, query)
data$subchannel <- gsub("[^a-zA-Z]+", " ", data$subchannel)
data$subchannel <- gsub("[ ]+$", "", data$subchannel)

online <- reshape(data[, 1:3], v.names="channelweight", timevar="mn",
                  idvar="subchannel", direction="wide")
names(online)[2:ncol(online)] <- gsub("channelweight.", "", names(online)[2:ncol(online)])
online[, 2:ncol(online)] <- online[, order(names(online)[2:ncol(online)])+1]
names(online)[2:ncol(online)] <- month.name[1:6]
online[is.na(online)] <- 0


tv.lst <- split(data$tvweight, data$mn)
tv.bymonth <- unlist(lapply(tv.lst, sum))
tv <- data.frame(subchannel="TV", 
                 January=tv.bymonth[1], February=tv.bymonth[2], March=tv.bymonth[3],
                 April=tv.bymonth[4], May=tv.bymonth[5], June=tv.bymonth[6])

monthly <- rbind(tv, online)
monthly$Total <- rowSums(monthly[, 2:7])
monthly <- monthly[order(monthly$Total, decreasing=T), ]

write.csv(monthly, 
          file="\\\\corpshares\\Analytics\\Feng\\AttrNew\\results\\au_lt_monthly.csv", 
          row.names=F)

query <- 'select datepart(month, servertimemst) mn, subchannel
               , sum(multitouchweights_update) channelweight
               , sum(tvweights_mt) tvweight
          from a.feng_au_visit_tv_signup
          group by datepart(month, servertimemst), subchannel'

data <- sqlQuery(.dwMatrix, query)
data$subchannel <- gsub("[^a-zA-Z]+", " ", data$subchannel)
data$subchannel <- gsub("[ ]+$", "", data$subchannel)

online <- reshape(data[, 1:3], v.names="channelweight", timevar="mn",
                  idvar="subchannel", direction="wide")
names(online)[2:ncol(online)] <- gsub("channelweight.", "", names(online)[2:ncol(online)])
online[, 2:ncol(online)] <- online[, order(names(online)[2:ncol(online)])+1]
names(online)[2:ncol(online)] <- month.name[1:6]
online[is.na(online)] <- 0


tv.lst <- split(data$tvweight, data$mn)
tv.bymonth <- unlist(lapply(tv.lst, sum))
tv <- data.frame(subchannel="TV", 
                 January=tv.bymonth[1], February=tv.bymonth[2], March=tv.bymonth[3],
                 April=tv.bymonth[4], May=tv.bymonth[5], June=tv.bymonth[6])

monthly <- rbind(tv, online)
monthly$Total <- rowSums(monthly[, 2:7])
monthly <- monthly[order(monthly$Total, decreasing=T), ]

write.csv(monthly, 
          file="\\\\corpshares\\Analytics\\Feng\\AttrNew\\results\\au_mt_monthly.csv", 
          row.names=F)
