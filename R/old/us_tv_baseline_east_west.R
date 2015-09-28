library(dplyr)

query <- "select *, cast(datetimemst as varchar(100)) datetimemststr
          from a.feng_ustv_2014jan_2015jul"

ustv <- sqlQuery(.dwMatrix, query)
ustv <- ustv[!is.na(ustv$datetimemststr), ]

unifnw <- ustv[, c("datetimemststr", "uniformnetwork")]
unifnw <- unifnw[order(unifnw$datetimemststr), ]
unifnw$datetimemststr <- as.character(unifnw$datetimemststr)
unifnw$uniformnetwork <- as.character(unifnw$uniformnetwork)
unifnw1 <- data.frame(group_by(unifnw, datetimemststr, uniformnetwork) %>% summarise(count=n()))
us.tvnw <- reshape(unifnw1, v.names="count", timevar="uniformnetwork",
                   idvar="datetimemststr", direction="wide")
names(us.tvnw)[2:ncol(us.tvnw)] <- gsub("count.", "", names(us.tvnw)[2:ncol(us.tvnw)])
names(us.tvnw)[2:ncol(us.tvnw)] <- gsub("[ ,]+", "", names(us.tvnw)[2:ncol(us.tvnw)])
us.tvnw[is.na(us.tvnw)] <- 0
spots100 <- which(colSums(us.tvnw[2:ncol(us.tvnw)]) >= 100) + 1
us.tvnw.100.east <- us.tvnw[, c(1, spots100)]
us.tvnw.100.west <- us.tvnw.100.east
us.tvnw.100.west$datetimemststr <- as.character(strptime(us.tvnw.100.west$datetimemststr, 
                                                         "%Y-%m-%d %H:%M:%S") +
                                                  60 * 60 * 3)
names(us.tvnw.100.east) <- c("datetimemst",
                             paste(names(us.tvnw.100.east)[2:ncol(us.tvnw.100.east)], "_E", sep=""))
names(us.tvnw.100.west) <- c("datetimemst",
                             paste(names(us.tvnw.100.west)[2:ncol(us.tvnw.100.west)], "_W", sep=""))


us.tvnw <- merge(us.tvnw.100.east, us.tvnw.100.west, all.x=T, all.y=T)
us.tvnw[is.na(us.tvnw)] <- 0

par(mfrow=c(2, 4), mar=c(2, 1, 2, 0))

query <- 
  "select substr(cast(servertimemst as varchar(100)), 1, 16) || ':00' timetomin, count(*) cnt
   from a.feng_us2015_visitandtv
   where ustimezone in ('EST', 'CST')
      and subchannel in ('Paid Search - Brand', 'Organic Brand')
   group by 1"

data <- sqlQuery(.dwMatrix, query)
data <- data[order(data$timetomin), ]
plot(strptime(data$timetomin[(24*60*3+1):(24*60*4)], "%Y-%m-%d %H:%M:%S"), 
     data$cnt[(24*60*3+1):(24*60*4)], type="l",
     main="Brand Search", ylab="")

query2 <- 
  "select substr(cast(servertimemst as varchar(100)), 1, 16) || ':00' timetomin, count(*) cnt
   from a.feng_us2015_visitandtv
   where ustimezone in ('EST', 'CST')
      and subchannel in ('Paid Search - NonBrand', 'Organic NonBrand')
   group by 1"

data2 <- sqlQuery(.dwMatrix, query2)
data2 <- data2[order(data2$timetomin), ]
ts.plot(data2$cnt[(24*60*3+1):(24*60*4)], main="NonBrand Search", ylab="")

query3 <- 
  "select substr(cast(servertimemst as varchar(100)), 1, 16) || ':00' timetomin, count(*) cnt
   from a.feng_us2015_visitandtv
   where ustimezone in ('EST', 'CST')
      and subchannel = 'Direct Homepage'
   group by 1"

data3 <- sqlQuery(.dwMatrix, query3)
data3 <- data3[order(data3$timetomin), ]
ts.plot(data3$cnt[(24*60*3+1):(24*60*4)], main="Direct Homepage", ylab="")

query4 <- 
  "select substr(cast(servertimemst as varchar(100)), 1, 16) || ':00' timetomin, count(*) cnt
   from a.feng_us2015_visitandtv
   where ustimezone in ('EST', 'CST')
      and subchannel = 'Direct Non-Homepage'
   group by 1"

data4 <- sqlQuery(.dwMatrix, query4)
data4 <- data4[order(data4$timetomin), ]
ts.plot(data4$cnt[(24*60*3+1):(24*60*4)], main="Direct Non-Homepage", ylab="")

query5 <- 
  "select substr(cast(servertimemst as varchar(100)), 1, 16) || ':00' timetomin, count(*) cnt
   from a.feng_us2015_visitandtv
   where ustimezone in ('EST', 'CST')
      and subchannel like '%Email%'
   group by 1"

data5 <- sqlQuery(.dwMatrix, query5)
data5 <- data5[order(data5$timetomin), ]
ts.plot(data5$cnt[(24*60*3+1):(24*60*4)], main="Email", ylab="")

query6 <- 
  "select substr(cast(servertimemst as varchar(100)), 1, 16) || ':00' timetomin, count(*) cnt
   from a.feng_us2015_visitandtv
   where ustimezone in ('EST', 'CST')
      and subchannel = 'Content Marketing'
   group by 1"

data6 <- sqlQuery(.dwMatrix, query6)
data6 <- data6[order(data6$timetomin), ]
ts.plot(data6$cnt[(24*60*3+1):(24*60*4)], main="Content Marketing", ylab="")

query7 <- 
  "select substr(cast(servertimemst as varchar(100)), 1, 16) || ':00' timetomin, count(*) cnt
   from a.feng_us2015_visitandtv
   where ustimezone in ('EST', 'CST')
      and subchannel = 'Internal Referrals'
   group by 1"

data7 <- sqlQuery(.dwMatrix, query7)
data7 <- data7[order(data7$timetomin), ]
ts.plot(data7$cnt[(24*60*3+1):(24*60*4)], main="Internal Referrals", ylab="")

query8 <- 
  "select substr(cast(servertimemst as varchar(100)), 1, 16) || ':00' timetomin, count(*) cnt
   from a.feng_us2015_visitandtv
   where ustimezone in ('EST', 'CST')
      and subchannel = 'iOS App'
   group by 1"

data8 <- sqlQuery(.dwMatrix, query8)
data8 <- data8[order(data8$timetomin), ]
ts.plot(data8$cnt[(24*60*3+1):(24*60*4)], main="iOS App", ylab="")
