query <- "select * from a.feng_us_attribution_3touches_monthly"

data <- sqlQuery(.dwMatrix, query=query)

firsttouch <- reshape(data[, 1:3], v.names="firsttouch",
                      timevar="month", idvar="subchannel", direction="wide")
firsttouch <- firsttouch[, c("subchannel", sort(names(firsttouch)[2:7]))]
names(firsttouch) <- c("subchannel", "Jan", "Feb", "Mar", "Apr", "May", "Jun")
firsttouch <- firsttouch[order(firsttouch$Jan, decreasing=T), ]
firsttouch$subchannel <- gsub("[^a-zA-Z0-9\\ ]+", "-", firsttouch$subchannel)
firsttouch[is.na(firsttouch)] <- 0
write.csv(firsttouch, file="C:/Users/fyi/Desktop/firsttouch.csv", row.names=F)

lasttouch <- reshape(data[, c(1, 2, 4)], v.names="lasttouch",
                      timevar="month", idvar="subchannel", direction="wide")
lasttouch <- lasttouch[, c("subchannel", sort(names(lasttouch)[2:7]))]
names(lasttouch) <- c("subchannel", "Jan", "Feb", "Mar", "Apr", "May", "Jun")
lasttouch <- lasttouch[order(lasttouch$Jan, decreasing=T), ]
lasttouch$subchannel <- gsub("[^a-zA-Z0-9\\ ]+", "-", lasttouch$subchannel)
lasttouch[is.na(lasttouch)] <- 0
write.csv(lasttouch, file="C:/Users/fyi/Desktop/lasttouch.csv", row.names=F)

multitouch <- reshape(data[, c(1, 2, 5)], v.names="multitouch",
                     timevar="month", idvar="subchannel", direction="wide")
multitouch <- multitouch[, c("subchannel", sort(names(multitouch)[2:7]))]
names(multitouch) <- c("subchannel", "Jan", "Feb", "Mar", "Apr", "May", "Jun")
multitouch <- multitouch[order(multitouch$Jan, decreasing=T), ]
multitouch$subchannel <- gsub("[^a-zA-Z0-9\\ ]+", "-", multitouch$subchannel)
multitouch[is.na(multitouch)] <- 0
write.csv(multitouch, file="C:/Users/fyi/Desktop/multitouch.csv", row.names=F)
