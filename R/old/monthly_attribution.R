query <- 'select datepart(month, servertimemst) mn, subchannel
               , sum(multitouchweights_update_decay) channelweight
               , sum(tvweights_mt_decay) tvweight
          from a.feng_us_visit_tv_signup
          group by datepart(month, servertimemst), subchannel'

data <- sqlQuery(.dwMatrix, query)
data$subchannel <- gsub("[^a-zA-Z]+", " ", data$subchannel)
data$subchannel <- gsub("[ ]+$", "", data$subchannel)

online <- reshape(data[, 1:3], v.names="channelweight", timevar="mn",
                  idvar="subchannel", direction="wide")
names(online)[2:ncol(online)] <- gsub("channelweight.", "", names(online)[2:ncol(online)])
online[, 2:ncol(online)] <- online[, order(names(online)[2:ncol(online)])+1]
names(online)[2:ncol(online)] <- month.name[1:7]
online[is.na(online)] <- 0


tv.lst <- split(data$tvweight, data$mn)
tv.bymonth <- unlist(lapply(tv.lst, sum))
tv <- data.frame(subchannel="TV", 
                 January=tv.bymonth[1], February=tv.bymonth[2], March=tv.bymonth[3],
                 April=tv.bymonth[4], May=tv.bymonth[5], June=tv.bymonth[6], 
                 July=tv.bymonth[7])

monthly <- rbind(tv, online)
monthly$Total <- rowSums(monthly[, 2:8])
monthly <- monthly[order(monthly$Total, decreasing=T), ]

write.csv(monthly, file="C://Users//fyi//Desktop/us_multitouch_decay_monthly.csv", 
          row.names=F)
