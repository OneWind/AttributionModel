library(dplyr)

query1 <- 
  "select visitnumber
   from a.feng_visitandsignup
   where freetrialorders > 0
  "
ftVisit <- sqlQuery(.dwMatrix, query1)

ftVtNum <- group_by(ftVisit, visitnumber) %>%
  summarise(count = n())
write.csv(ftVtNum, "ftVtNum.csv", row.names=F)


query2 <- 
  "select visitnumber
   from a.feng_visitandsignup
   where hardofferorders > 0
  "
hoVisit <- sqlQuery(.dwMatrix, query2)

hoVtNum <- group_by(hoVisit, visitnumber) %>%
  summarise(count = n())
write.csv(hoVtNum, "hoVtNum.csv", row.names=F)
